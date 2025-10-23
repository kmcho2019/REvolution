module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q = 0
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule