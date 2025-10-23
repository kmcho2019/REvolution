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
    localparam ABOVE    = 2'b00;
    localparam MID_HIGH = 2'b01;
    localparam MID_LOW  = 2'b10;
    localparam BELOW    = 2'b11;

    reg [1:0] state, next_state;
    reg was_rising;

    // State transition logic
    always @(*) begin
        case (state)
            ABOVE:    next_state = (s[2]) ? ABOVE    : MID_HIGH;
            MID_HIGH: next_state = (s[2]) ? ABOVE    : 
                                 (s[1]) ? MID_HIGH : MID_LOW;
            MID_LOW:  next_state = (s[1]) ? MID_HIGH :
                                 (s[0]) ? MID_LOW  : BELOW;
            BELOW:    next_state = (s[0]) ? MID_LOW  : BELOW;
            default:  next_state = BELOW;
        endcase
    end

    // State and direction update
    always @(posedge clk) begin
        if (reset) begin
            state <= BELOW;
            was_rising <= 1'b0;
        end else begin
            if (state != next_state) begin
                was_rising <= (next_state < state); // Lower value = higher level
            end
            state <= next_state;
        end
    end

    // Output logic - direct mapping from state
    always @(*) begin
        case (state)
            ABOVE:    {fr2, fr1, fr0} = 3'b000;
            MID_HIGH: {fr2, fr1, fr0} = 3'b001;
            MID_LOW:  {fr2, fr1, fr0} = 3'b011;
            BELOW:    {fr2, fr1, fr0} = 3'b111;
            default:  {fr2, fr1, fr0} = 3'b111;
        endcase

        // dfr is 1 when rising and in intermediate states
        dfr = was_rising && (state == MID_HIGH || state == MID_LOW);
    end

endmodule