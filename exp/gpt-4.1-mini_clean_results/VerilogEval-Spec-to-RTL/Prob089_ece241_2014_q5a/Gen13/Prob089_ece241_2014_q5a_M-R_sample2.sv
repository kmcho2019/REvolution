module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg state;    // 0: copy bits, 1: invert bits
    reg x_reg;    // sampled input bit

    // Sample input x synchronously
    always @(posedge clk) begin
        if (!areset) begin
            x_reg <= x;
        end else begin
            x_reg <= 1'b0;
        end
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // reset to COPY state
        end else begin
            case(state)
                1'b0: state <= (x_reg == 1'b1) ? 1'b1 : 1'b0;
                1'b1: state <= 1'b1;
                default: state <= 1'b0;
            endcase
        end
    end

    // Moore output: registered input XOR state
    assign z = x_reg ^ state;

endmodule