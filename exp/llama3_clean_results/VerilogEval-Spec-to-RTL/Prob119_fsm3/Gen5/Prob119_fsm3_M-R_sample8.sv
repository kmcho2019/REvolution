module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;

// Next state logic and state register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
    begin
        case(state)
            A: state <= (in == 1'b0)? A : B;
            B: state <= (in == 1'b0)? C : B;
            C: state <= (in == 1'b0)? A : D;
            D: state <= (in == 1'b0)? C : B;
            default: state <= A;
        endcase
    end
end

// Output logic
always @(*)
begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule