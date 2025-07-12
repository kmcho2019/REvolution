module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

assign z = (A === B)? 1'b1 : 1'b0;

// Alternatively, using a case statement for explicit comparison:
// always @(*) begin
//     case ({A, B})
//         4'b0000, 4'b0001, 4'b0010, 4'b0011, 
//         4'b0100, 4'b0101, 4'b0110, 4'b0111, 
//         4'b1000, 4'b1001, 4'b1010, 4'b1011, 
//         4'b1100, 4'b1101, 4'b1110, 4'b1111: 
//             if (A === B) z = 1'b1; else z = 1'b0;
//     endcase
// end

endmodule