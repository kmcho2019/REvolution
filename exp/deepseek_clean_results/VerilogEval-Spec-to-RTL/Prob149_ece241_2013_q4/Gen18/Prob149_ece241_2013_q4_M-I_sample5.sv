module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding (binary reflecting water level)
    localparam STATE_BELOW_S0  = 2'b00; // Lowest
    localparam STATE_BTW_S1_S0 = 2'b01;
    localparam STATE_BTW_S2_S1 = 2'b10;
    localparam STATE_ABOVE_S2  = 2'b11; // Highest

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111: next_state = STATE_ABOVE_S2;
            3'b011: next_state = STATE_BTW_S2_S1;
            3'b001: next_state = STATE_BTW_S1_S0;
            3'b000: next_state = STATE_BELOW_S0;
            default: next_state = STATE_BELOW_S0; // Default to lowest state
        endcase
    end

    // State registers and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Output logic
            case (next_state)
                STATE_ABOVE_S2:  {fr2, fr1, fr0} = 3'b000;
                STATE_BTW_S2_S1: {fr2, fr1, fr0} = 3'b001;
                STATE_BTW_S1_S0: {fr2, fr1, fr0} = 3'b011;
                STATE_BELOW_S0: {fr2, fr1, fr0} = 3'b111;
            endcase

            // Supplemental flow (rising level detection)
            // Higher water level has higher state value
            dfr <= (next_state > prev_state);
        end
    end

endmodule