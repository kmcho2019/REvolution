module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q = 0
);

always_ff @(posedge clk) begin
    q <= d;
end

// Alternatively, explicit instantiation of DFFs
// logic [7:0] q_reg = 0;
// always_ff @(posedge clk) begin
//     for (int i = 0; i < 8; i++) begin
//         q_reg[i] <= d[i];
//     end
// end
// assign q = q_reg;

endmodule