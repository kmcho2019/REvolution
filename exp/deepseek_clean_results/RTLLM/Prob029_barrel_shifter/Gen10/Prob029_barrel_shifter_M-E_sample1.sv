module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    // Calculate total rotation amount (0-7)
    wire [2:0] rot_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);
    
    always @(*) begin
        // For each output bit, select input bit with rotation offset
        for (int i = 0; i < 8; i = i + 1) begin
            out[i] = in[(i + rot_amount) % 8];
        end
    end
endmodule