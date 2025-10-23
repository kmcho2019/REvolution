module TopModule(
    input         clk,
    input  [7:0]  d,
    output logic [7:0]  q // Declare 'q' as a logic type
);

always_ff @(posedge clk) begin
    q <= d; // This directly implements 8 D flip-flops
end

endmodule