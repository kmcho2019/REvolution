module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    always @(*) begin
        // Calculate total shift amount (0-7)
        wire [2:0] shift_amount = {ctrl[2], 1'b0, 1'b0} |  // 4 if ctrl[2]
                                 {1'b0, ctrl[1], 1'b0} |  // 2 if ctrl[1]
                                 {1'b0, 1'b0, ctrl[0]};    // 1 if ctrl[0]
        
        // Perform the rotation in one operation
        out = (in >> shift_amount) | (in << (8 - shift_amount));
    end
endmodule