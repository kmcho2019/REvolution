module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    // State encoding
    localparam STABLE_LOW  = 2'b00;
    localparam RISING_EDGE = 2'b01;
    localparam FALLING_EDGE = 2'b10;
    localparam STABLE_HIGH = 2'b11;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STABLE_LOW:  next_state = a ? RISING_EDGE : STABLE_LOW;
            RISING_EDGE: next_state = STABLE_HIGH;
            STABLE_HIGH: next_state = a ? STABLE_HIGH : FALLING_EDGE;
            FALLING_EDGE: next_state = STABLE_LOW;
            default: next_state = STABLE_LOW;
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STABLE_LOW;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign rise = (state == RISING_EDGE);
    assign down = (state == FALLING_EDGE);

endmodule