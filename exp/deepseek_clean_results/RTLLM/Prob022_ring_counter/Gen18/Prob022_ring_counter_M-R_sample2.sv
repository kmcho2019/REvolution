module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

parameter INIT_STATE = 8'b00000001;
wire [7:0] next_state;

// Combinational logic for next state
assign next_state = reset ? INIT_STATE : 
                   {out[6:0], out[7]};

// Sequential logic for state transition
always @(posedge clk) begin
    out <= next_state;
end

endmodule