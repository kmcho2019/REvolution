module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
    begin
        case(state)
            A: state <= (in == 1'b0) ? A : B;
            B: state <= (in == 1'b0) ? C : B;
            C: state <= (in == 1'b0) ? A : D;
            D: state <= (in == 1'b0) ? C : B;
            default: state <= A;
        endcase
    end
end

// Output logic
assign out = (state == D);

endmodule