module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] ff;
    reg rst_sync;

    // Internal synchronous reset: active at the first clock cycle after power-on
    initial begin
        rst_sync = 1'b1;
    end

    always @(posedge clk) begin
        if (rst_sync)
            rst_sync <= 1'b0; // release reset after first clock
    end

    wire d_xor = x ^ ff[2];
    wire d_and = x & ~ff[1];
    wire d_or  = x | ~ff[0];

    always @(posedge clk) begin
        if (rst_sync)
            ff <= 3'b000;
        else
            ff <= {d_xor, d_and, d_or};
    end

    assign z = ~(ff[2] | ff[1] | ff[0]);

endmodule