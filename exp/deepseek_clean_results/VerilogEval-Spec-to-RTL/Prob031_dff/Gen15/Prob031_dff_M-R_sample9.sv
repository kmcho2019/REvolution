module TopModule (
    input clk,
    input d,
    output reg q
);

reg master_out;

always @(posedge clk) begin
    master_out <= d;    // Master stage captures on rising edge
    q <= master_out;    // Slave stage updates on rising edge
end

endmodule