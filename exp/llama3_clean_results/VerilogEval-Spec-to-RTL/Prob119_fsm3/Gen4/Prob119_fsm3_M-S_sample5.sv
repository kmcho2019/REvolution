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

// State register with asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
    begin
        case(state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
assign out = (state == D);

endmodule