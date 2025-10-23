module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

// Parameters
parameter INIT_STATE = 8'b00000001;

// Internal state register
reg [7:0] state;

// Next state logic (combinational)
wire [7:0] next_state;
assign next_state = reset ? INIT_STATE : {state[6:0], state[7]};

// State register (sequential)
always @(posedge clk) begin
    state <= next_state;
end

// Output assignment
assign out = state;

endmodule