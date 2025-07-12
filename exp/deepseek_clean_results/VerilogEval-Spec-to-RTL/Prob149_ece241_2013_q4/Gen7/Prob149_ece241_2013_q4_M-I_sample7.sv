module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level states
    localparam ABOVE_ALL  = 2'b00;  // Above s[2]
    localparam MID_HIGH   = 2'b01;  // Between s[2] and s[1]
    localparam MID_LOW    = 2'b10;  // Between s[1] and s[0]
    localparam BELOW_ALL  = 2'b11;  // Below s[0]

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;

    // State transition logic
    always @(*) begin
        case (s)
            3'b111: next_state = ABOVE_ALL;
            3'b011: next_state = MID_HIGH;
            3'b001: next_state = MID_LOW;
            3'b000: next_state = BELOW_ALL;
            default: next_state = current_state; // Handle undefined cases
        endcase
    end

    // State registers and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW_ALL;
            prev_state <= BELOW_ALL;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;

            // Output logic
            case (next_state)
                ABOVE_ALL: {fr2, fr1, fr0} = 3'b000;
                MID_HIGH:  {fr2, fr1, fr0} = 3'b001;
                MID_LOW:   {fr2, fr1, fr0} = 3'b011;
                BELOW_ALL: {fr2, fr1, fr0} = 3'b111;
                default:   {fr2, fr1, fr0} = 3'b000;
            endcase

            // Supplemental flow when level is rising
            dfr <= (next_state > prev_state);
        end
    end

endmodule