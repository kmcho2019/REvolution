module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
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
            ABOVE:    next_state = s[2] ? ABOVE    : MID_HIGH;
            MID_HIGH: next_state = s[2] ? ABOVE    : 
                                 s[1] ? MID_HIGH : MID_LOW;
            MID_LOW:  next_state = s[1] ? MID_HIGH :
                                 s[0] ? MID_LOW  : BELOW;
            BELOW:    next_state = s[0] ? MID_LOW  : BELOW;
            default:  next_state = BELOW;
        endcase
    end

    // State and direction update
    always @(posedge clk) begin
        if (reset) begin
            state <= BELOW;
            was_rising <= 1'b0;  // Coming from long-time low condition
        end else begin
            if (state != next_state) begin
                was_rising <= (next_state < state);  // Lower value means higher level
            end
            state <= next_state;
        end
    end

    // Output logic - continuous assignments
    assign fr2 = (state == BELOW);
    assign fr1 = (state == BELOW) || (state == MID_LOW);
    assign fr0 = (state == BELOW) || (state == MID_LOW) || (state == MID_HIGH);
    assign dfr = was_rising && (state == MID_HIGH || state == MID_LOW);

endmodule