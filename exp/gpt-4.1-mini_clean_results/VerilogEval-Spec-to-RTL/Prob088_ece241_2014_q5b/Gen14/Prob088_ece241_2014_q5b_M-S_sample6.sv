module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state; // One-hot: 2'b01 = A, 2'b10 = B

localparam A = 2'b01,
           B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else begin
        case(state)
            A: state <= (x) ? B : A;
            B: state <= B;
            default: state <= A; // safe default
        endcase
    end
end

// Mealy output logic
always @(*) begin
    case(state)
        A: z = x;
        B: z = ~x;
        default: z = 0;
    endcase
end

endmodule