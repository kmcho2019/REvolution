module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding:
    // 0 = COPY (no inversion yet)
    // 1 = INVERT (invert subsequent bits)
    reg state;
    reg x_reg;

    // Sequential logic: sample input and update state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;   // COPY state, no inversion
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            case(state)
                1'b0: state <= (x_reg == 1'b1) ? 1'b1 : 1'b0;
                1'b1: state <= 1'b1;
                default: state <= 1'b0;
            endcase
        end
    end

    // Moore output: depends only on registered state and input
    always @(*) begin
        z = x_reg ^ state; // output is input XOR inversion state
    end

endmodule