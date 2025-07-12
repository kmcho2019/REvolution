module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the number of states
parameter NUM_STATES = 4;

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// Next state logic using assign
wire [1:0] next_state;
assign next_state = (state == A)         ? (in == 1'b0) ? A : B :
                     (state == B)         ? (in == 1'b0) ? C : B :
                     (state == C)         ? (in == 1'b0) ? A : D :
                     (state == D)         ? (in == 1'b0) ? C : B :
                                             A; // default state

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

// Output logic
assign out = (state == D);

endmodule