module TopModule (
    input clk,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        state <= in ^ state;
    end

    assign out = state;

    // Optional initialization for simulation purposes
    initial begin
        state = 1'b0;
    end

endmodule