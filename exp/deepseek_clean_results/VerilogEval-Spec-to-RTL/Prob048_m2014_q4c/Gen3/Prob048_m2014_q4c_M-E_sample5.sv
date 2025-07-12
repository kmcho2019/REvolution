module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire mux_out;

assign mux_out = r ? 1'b0 : d;

always @(posedge clk) begin
    q <= mux_out;
end

endmodule