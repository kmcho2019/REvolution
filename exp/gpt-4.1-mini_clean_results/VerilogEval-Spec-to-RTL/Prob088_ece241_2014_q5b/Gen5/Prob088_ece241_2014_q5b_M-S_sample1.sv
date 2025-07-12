module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg [1:0] state; // one-hot: 01 = A, 10 = B

// State encoding
localparam A = 2'b01,
           B = 2'b10;

// Next state logic and state register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else begin
        case (state)
            A: state <= x ? B : A;
            B: state <= B;
            default: state <= A; // safe default
        endcase
    end
end

// Output logic (Mealy)
assign z = (state == A) ? x : ~x;

endmodule