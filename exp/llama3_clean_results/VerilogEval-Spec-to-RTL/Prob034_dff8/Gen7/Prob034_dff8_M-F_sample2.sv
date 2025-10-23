module TopModule(
    input clk,
    input logic [7:0] d,
    output logic [7:0] q
);

always_ff @(posedge clk) begin
    q <= d; // Assign d to q on the positive edge of clk
end

endmodule