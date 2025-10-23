module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    // Generate all possible shifted versions
    wire [7:0] shift1 = {in[6:0], in[7]};    // 1-bit rotate right
    wire [7:0] shift2 = {in[5:0], in[7:6]};  // 2-bit rotate right
    wire [7:0] shift4 = {in[3:0], in[7:4]};  // 4-bit rotate right
    
    // Priority selection logic
    always @(*) begin
        casex (ctrl)
            3'b1??: out = shift4;  // Highest priority (4-bit shift)
            3'b01?: out = shift2;  // Medium priority (2-bit shift)
            3'b001: out = shift1;  // Lowest priority (1-bit shift)
            default: out = in;     // No shift
        endcase
    end
endmodule