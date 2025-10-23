module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states using one-hot encoding
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0100;
parameter D = 4'b1000;

// State registers
reg [3:0] current_state;
reg [3:0] next_state;

// Next state logic
always @(posedge clk or posedge areset)
begin
    if(areset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output logic
always @(*)
begin
    case(current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// Output logic
assign out = (current_state == D) ? 1'b1 : 1'b0;

endmodule