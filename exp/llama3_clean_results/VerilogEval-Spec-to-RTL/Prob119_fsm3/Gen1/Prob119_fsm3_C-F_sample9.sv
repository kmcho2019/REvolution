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
reg [1:0] next_state;

// Next state logic
always @(*)
begin
    case(state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
        state <= next_state;
end

// Output logic
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule