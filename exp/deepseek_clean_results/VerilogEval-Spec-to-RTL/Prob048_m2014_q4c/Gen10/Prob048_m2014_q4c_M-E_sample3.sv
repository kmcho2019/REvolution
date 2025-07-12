module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire mux_out;

// Reset mux logic
assign mux_out = r ? 1'b0 : d;

// Basic DFF without reset
always @(posedge clk) begin
    q <= mux_out;
end

endmodule