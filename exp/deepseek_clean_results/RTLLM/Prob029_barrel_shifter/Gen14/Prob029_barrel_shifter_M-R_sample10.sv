module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Compute all possible shifts in parallel
    wire [7:0] shift1 = {in[0], in[7:1]};          // 1-bit right rotation
    wire [7:0] shift2 = {in[1:0], in[7:2]};        // 2-bit right rotation
    wire [7:0] shift4 = {in[3:0], in[7:4]};        // 4-bit right rotation
    
    // Apply shifts based on control bits
    wire [7:0] stage1 = ctrl[0] ? shift1 : in;
    wire [7:0] stage2 = ctrl[1] ? shift2 : in;
    wire [7:0] stage4 = ctrl[2] ? shift4 : in;
    
    // Combine enabled shifts (note: shifts are powers of 2 so they don't overlap)
    assign out = (ctrl[0] ? stage1 : 8'b0) |
                 (ctrl[1] ? stage2 : 8'b0) |
                 (ctrl[2] ? stage4 : 8'b0);
endmodule