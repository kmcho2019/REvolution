module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] ff;
    reg reset_done;

    wire d_xor = x ^ ff[2];
    wire d_and = x & ~ff[1];
    wire d_or  = x | ~ff[0];

    always @(posedge clk) begin
        if (!reset_done) begin
            ff <= 3'b000;       // synchronous reset to zero at first clock
            reset_done <= 1'b1;
        end else begin
            ff <= {d_xor, d_and, d_or};
        end
    end

    assign z = ~(ff[2] | ff[1] | ff[0]);

endmodule