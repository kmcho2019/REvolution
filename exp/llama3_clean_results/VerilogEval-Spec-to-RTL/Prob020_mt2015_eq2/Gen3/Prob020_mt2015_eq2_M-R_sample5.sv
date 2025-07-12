module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

always @(*) begin
    // Compare A and B, setting z to 1 if they are equal, and 0 otherwise
    if (A == B) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule