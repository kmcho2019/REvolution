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

// Next state logic
always @(*)
begin
    case(state)
        A: state <= (in == 1'b0)? A : B;
        B: state <= (in == 1'b0)? C : B;
        C: state <= (in == 1'b0)? A : D;
        D: state <= (in == 1'b0)? C : B;
        default: state <= A;
    endcase
end

// However, to correctly implement the asynchronous reset and synchronous state update,
// we should use a separate always block for the state register update.
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