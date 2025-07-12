module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output reg  A_greater,
    output reg  A_equal,
    output reg  A_less
);

// Internal wires for subtraction result and borrow
wire [3:0] result;
reg  [3:0] borrow;

// Full subtractor for each bit position
assign result[0] = A[0] - B[0];
assign borrow[0] = (A[0] < B[0]) ? 1'b1 : 1'b0;

assign result[1] = A[1] - B[1] - borrow[0];
assign borrow[1] = (A[1] + ~borrow[0] < B[1]) ? 1'b1 : 1'b0;

assign result[2] = A[2] - B[2] - borrow[1];
assign borrow[2] = (A[2] + ~borrow[1] < B[2]) ? 1'b1 : 1'b0;

assign result[3] = A[3] - B[3] - borrow[2];

// Output logic to determine relationship
always @(A, B) begin
    if (borrow[3]) begin
        A_greater = 1'b0;
        A_equal  = 1'b0;
        A_less   = 1'b1;
    end else if (result == 4'b0000) begin
        A_greater = 1'b0;
        A_equal  = 1'b1;
        A_less   = 1'b0;
    end else begin
        A_greater = 1'b1;
        A_equal  = 1'b0;
        A_less   = 1'b0;
    end
end

endmodule