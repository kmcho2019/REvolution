module barrel_shifter(
    input [7:0] in,        // 8-bit input to be rotated
    input [2:0] ctrl,      // Control bits: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output reg [7:0] out   // Rotated output
);

    // Combined rotation logic in a single always block
    always @(*) begin
        case (ctrl)
            3'b000: out = in;                     // No rotation
            3'b001: out = {in[0], in[7:1]};       // 1-bit right rotation
            3'b010: out = {in[1:0], in[7:2]};     // 2-bit right rotation
            3'b011: out = {in[2:0], in[7:3]};     // 3-bit (1+2) right rotation
            3'b100: out = {in[3:0], in[7:4]};     // 4-bit right rotation
            3'b101: out = {in[4:0], in[7:5]};     // 5-bit (4+1) right rotation
            3'b110: out = {in[5:0], in[7:6]};     // 6-bit (4+2) right rotation
            3'b111: out = {in[6:0], in[7]};       // 7-bit (4+2+1) right rotation
            default: out = in;                    // Default case (shouldn't occur)
        endcase
    end

endmodule