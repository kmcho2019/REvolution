module TopModule #(
    parameter REGISTERED = 0  // 0: combinational, 1: registered
)(
    input [1:0] A,
    input [1:0] B,
    input  clk,               // Only needed when REGISTERED=1
    output reg z
);

    wire z_comb = (A == B);

    generate
        if (REGISTERED) begin
            always @(posedge clk) begin
                z <= z_comb;
            end
        end else begin
            assign z = z_comb;
        end
    endgenerate

endmodule