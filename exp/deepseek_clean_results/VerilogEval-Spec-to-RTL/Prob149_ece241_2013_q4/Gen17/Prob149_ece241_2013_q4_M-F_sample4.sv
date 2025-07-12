module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding (one-hot)
    localparam STATE_ABOVE_S2  = 4'b1000;
    localparam STATE_BTW_S2_S1 = 4'b0100;
    localparam STATE_BTW_S1_S0 = 4'b0010;
    localparam STATE_BELOW_S0  = 4'b0001;

    reg [3:0] current_state, next_state;
    reg [3:0] prev_state;

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
                default: {fr2, fr1, fr0} = 3'b000;
            endcase

            // Supplemental flow (rising level detection)
            dfr <= (next_state > current_state);
        end
    end

endmodule