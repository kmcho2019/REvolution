module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Right rotation implementation
    wire [7:0] shift4_result;  // After potential 4-bit shift
    wire [7:0] shift2_result;  // After potential 2-bit shift
    wire [7:0] shift1_result;  // After potential 1-bit shift

    // Stage 1: 4-bit right rotation if ctrl[2] is set
    assign shift4_result = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: 2-bit right rotation if ctrl[1] is set
    assign shift2_result = ctrl[1] ? {shift4_result[1:0], shift4_result[7:2]} : shift4_result;

    // Stage 3: 1-bit right rotation if ctrl[0] is set
    assign shift1_result = ctrl[0] ? {shift2_result[0], shift2_result[7:1]} : shift2_result;

    // Final output assignment
    assign out = shift1_result;
endmodule