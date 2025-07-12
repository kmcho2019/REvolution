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

// Output logic
assign out = (state == D)? 1'b1 : 1'b0;

// State register with asynchronous reset and next state logic
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

endmodule