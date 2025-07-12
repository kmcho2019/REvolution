module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Define the lookup table as a case statement
always @(*) begin
    case ({A, B})
        4'b0000, 4'b0101, 4'b1010, 4'b1111: z = 1'b1; // A equals B
        default: z = 1'b0; // A does not equal B
    endcase
end

endmodule