module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate 24-bit register (16 quotient + 8 remainder)
    wire [23:0] div_result;

    // Calculate all quotient bits in parallel
    assign div_result[23:16] = 8'b0;  // Initial remainder
    assign div_result[15] = ({div_result[22:15], A[15]} >= B);
    assign div_result[14] = ({div_result[div_result[15] ? 22:15], A[15:14]} >= B);
    assign div_result[13] = ({div_result[div_result[14] ? 21:14], A[14:13]} >= B);
    assign div_result[12] = ({div_result[div_result[13] ? 20:13], A[13:12]} >= B);
    assign div_result[11] = ({div_result[div_result[12] ? 19:12], A[12:11]} >= B);
    assign div_result[10] = ({div_result[div_result[11] ? 18:11], A[11:10]} >= B);
    assign div_result[9]  = ({div_result[div_result[10] ? 17:10], A[10:9]} >= B);
    assign div_result[8]  = ({div_result[div_result[9] ? 16:9], A[9:8]} >= B);
    assign div_result[7]  = ({div_result[div_result[8] ? 15:8], A[8:7]} >= B);
    assign div_result[6]  = ({div_result[div_result[7] ? 14:7], A[7:6]} >= B);
    assign div_result[5]  = ({div_result[div_result[6] ? 13:6], A[6:5]} >= B);
    assign div_result[4]  = ({div_result[div_result[5] ? 12:5], A[5:4]} >= B);
    assign div_result[3]  = ({div_result[div_result[4] ? 11:4], A[4:3]} >= B);
    assign div_result[2]  = ({div_result[div_result[3] ? 10:3], A[3:2]} >= B);
    assign div_result[1]  = ({div_result[div_result[2] ? 9:2], A[2:1]} >= B);
    assign div_result[0]  = ({div_result[div_result[1] ? 8:1], A[1:0]} >= B);

    // Calculate final remainder
    wire [7:0] final_remainder = div_result[0] ? 
                                {div_result[7:0]} - B : 
                                {div_result[7:0]};

    // Output assignments
    assign result = div_result[15:0];
    assign odd = final_remainder;

endmodule