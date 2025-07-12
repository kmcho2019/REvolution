module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg state;  // 0: initial, 1: seen "10"

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 1'b0;
        end else begin
            state <= (state & x) | (~state & ~x);
        end
    end

    // Mealy output: detect "101" (state=1 and x=1)
    assign z = state & x;

endmodule