module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding
    localparam ABOVE_ALL  = 2'b00;  // s[2:0] = 111
    localparam MID_HIGH   = 2'b01;  // s[2:0] = 011
    localparam MID_LOW    = 2'b10;  // s[2:0] = 001
    localparam BELOW_ALL  = 2'b11;  // s[2:0] = 000

    reg [1:0] current_state, prev_state;

    // State detection
    always @(*) begin
        case (s)
            3'b111: current_state = ABOVE_ALL;
            3'b011: current_state = MID_HIGH;
            3'b001: current_state = MID_LOW;
            3'b000: current_state = BELOW_ALL;
            default: current_state = BELOW_ALL; // Handle unexpected patterns
        endcase
    end

    // State history tracking
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= BELOW_ALL;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_state <= current_state;

            // Nominal flow outputs
            case (current_state)
                ABOVE_ALL: {fr2, fr1, fr0} = 3'b000;
                MID_HIGH:  {fr2, fr1, fr0} = 3'b001;
                MID_LOW:   {fr2, fr1, fr0} = 3'b011;
                BELOW_ALL: {fr2, fr1, fr0} = 3'b111;
            endcase

            // Supplemental flow (dfr) logic
            case ({prev_state, current_state})
                {ABOVE_ALL, MID_HIGH}:  dfr <= 1'b0;  // Falling
                {ABOVE_ALL, MID_LOW}:   dfr <= 1'b0;  // Falling
                {ABOVE_ALL, BELOW_ALL}: dfr <= 1'b0;  // Falling
                {MID_HIGH, ABOVE_ALL}:  dfr <= 1'b1;  // Rising
                {MID_HIGH, MID_LOW}:    dfr <= 1'b0;  // Falling
                {MID_HIGH, BELOW_ALL}:  dfr <= 1'b0;  // Falling
                {MID_LOW, ABOVE_ALL}:   dfr <= 1'b1;  // Rising
                {MID_LOW, MID_HIGH}:   dfr <= 1'b1;  // Rising
                {MID_LOW, BELOW_ALL}:   dfr <= 1'b0;  // Falling
                {BELOW_ALL, ABOVE_ALL}: dfr <= 1'b1;  // Rising
                {BELOW_ALL, MID_HIGH}:  dfr <= 1'b1;  // Rising
                {BELOW_ALL, MID_LOW}:   dfr <= 1'b1;  // Rising
                default: dfr <= (current_state == BELOW_ALL); // Maintain or same state
            endcase
        end
    end

endmodule