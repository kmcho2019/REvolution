module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

wire [7:0] next_out;

// Combinational logic for next state
assign next_out = reset ? 8'b00000001 : 
                 {out[6:0], out[7]};

// Sequential logic for state update
always @(posedge clk) begin
    out <= next_out;
end

endmodule