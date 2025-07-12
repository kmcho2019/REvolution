module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_count;
wire count_eq_6;
wire [2:0] mux_out;

// Counter increment logic
assign next_count = q + 1'b1;

// Wrap-around detection
assign count_eq_6 = (q == 3'd6);

// Output multiplexer
assign mux_out = a ? 3'd4 : (count_eq_6 ? 3'd0 : next_count);

// Sequential logic
always @(posedge clk) begin
    q <= mux_out;
end

endmodule