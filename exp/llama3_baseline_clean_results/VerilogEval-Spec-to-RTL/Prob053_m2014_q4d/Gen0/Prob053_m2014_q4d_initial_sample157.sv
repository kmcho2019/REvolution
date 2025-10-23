module TopModule(
    input clk,
    input in,
    output reg out
);

reg temp_out;

assign temp_out = out ^ in;

always @(posedge clk) begin
    out <= temp_out;
end

endmodule