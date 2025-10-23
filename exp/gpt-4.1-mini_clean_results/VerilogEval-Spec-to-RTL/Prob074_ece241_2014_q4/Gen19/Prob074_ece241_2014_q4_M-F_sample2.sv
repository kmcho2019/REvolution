module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] ff;

    wire d_xor = x ^ ff[2];
    wire d_and = x & ~ff[1];
    wire d_or  = x | ~ff[0];

    // Initialize flip-flops to zero at simulation start to guarantee known state
    initial begin
        ff = 3'b000;
    end

    always @(posedge clk) begin
        ff <= {d_xor, d_and, d_or};
    end

    assign z = ~(ff[2] | ff[1] | ff[0]);

endmodule