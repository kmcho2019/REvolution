module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as parameters
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;

// Output logic using assign
assign out = (state == D)? 1'b1 : 1'b0;

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A;
        endcase
    end
end

endmodule