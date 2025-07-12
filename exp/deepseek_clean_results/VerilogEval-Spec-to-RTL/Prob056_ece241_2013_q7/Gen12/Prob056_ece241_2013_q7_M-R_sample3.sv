module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

assign next_Q = (j & k) ? ~Q :    // Toggle case
                (j) ? 1'b1 :      // Set case (J=1, K=0)
                (k) ? 1'b0 : Q;   // Reset or hold cases

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule