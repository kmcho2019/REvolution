module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    q <= reset ? 8'b0 : d;
end

endmodule