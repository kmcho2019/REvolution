module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Next state logic using assign
assign next_state = (state == A)        ? (in == 1'b0)? A : B :
                     (state == B)        ? (in == 1'b0)? C : B :
                     (state == C)        ? (in == 1'b0)? A : D :
                     (state == D)        ? (in == 1'b0)? C : B :
                                             A; // default state

// Output logic
assign out = (state == D)? 1'b1 : 1'b0;

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

endmodule