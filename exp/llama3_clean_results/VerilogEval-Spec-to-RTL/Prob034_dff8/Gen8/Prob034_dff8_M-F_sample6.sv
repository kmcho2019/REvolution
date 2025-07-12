module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

// Explicitly instantiate 8 D flip-flops
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        always @(posedge clk) begin
            q[i] <= d[i]; // Update each bit of 'q' with the corresponding bit of 'd' at the positive edge of the clock
        end
    end
endgenerate

endmodule