module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Define states for water levels
    localparam LEVEL_ABOVE_S2  = 2'b00;
    localparam LEVEL_BTW_S2_S1 = 2'b01;
    localparam LEVEL_BTW_S1_S0 = 2'b10;
    localparam LEVEL_BELOW_S0  = 2'b11;

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    wire level_rising;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111: next_state = LEVEL_ABOVE_S2;
            3'b011: next_state = LEVEL_BTW_S2_S1;
            3'b001: next_state = LEVEL_BTW_S1_S0;
            3'b000: next_state = LEVEL_BELOW_S0;
            default: next_state = current_state; // maintain state for invalid patterns
        endcase
    end

    // State register and previous state tracking
    always @(posedge clk) begin
        if (reset) begin
            current_state <= LEVEL_BELOW_S0;
            prev_state <= LEVEL_BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Determine if level is rising
    assign level_rising = (next_state < current_state); // states are ordered from high to low

    // Output logic
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            case (current_state)
                LEVEL_ABOVE_S2:  {fr2, fr1, fr0} = 3'b000;
                LEVEL_BTW_S2_S1: {fr2, fr1, fr0} = 3'b001;
                LEVEL_BTW_S1_S0: {fr2, fr1, fr0} = 3'b011;
                LEVEL_BELOW_S0: {fr2, fr1, fr0} = 3'b111;
                default:         {fr2, fr1, fr0} = 3'b000;
            endcase

            // dfr is asserted when level is rising and we're not at the highest level
            dfr = level_rising && (current_state != LEVEL_ABOVE_S2);
        end
    end

endmodule