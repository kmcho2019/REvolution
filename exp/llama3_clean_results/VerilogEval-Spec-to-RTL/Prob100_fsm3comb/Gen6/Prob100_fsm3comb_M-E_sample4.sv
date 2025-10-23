module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

// Define the next state for each current state and input combination
wire [1:0] next_state_A = (in)? 2'b01 : 2'b00;
wire [1:0] next_state_B = (in)? 2'b01 : 2'b10;
wire [1:0] next_state_C = (in)? 2'b11 : 2'b00;
wire [1:0] next_state_D = (in)? 2'b01 : 2'b10;

// Use a multiplexer to select the next state based on the current state
assign next_state = (state == 2'b00)? next_state_A :
                    (state == 2'b01)? next_state_B :
                    (state == 2'b10)? next_state_C :
                    (state == 2'b11)? next_state_D : 2'b00;

// Define the output for each state
assign out = (state == 2'b11)? 1'b1 : 1'b0;

endmodule