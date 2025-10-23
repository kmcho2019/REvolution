module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire mux_out;

// Multiplexer for reset functionality
assign mux_out = r ? 1'b0 : d;

// Basic D flip-flop
always @(posedge clk) begin
    q <= mux_out;
end

endmodule