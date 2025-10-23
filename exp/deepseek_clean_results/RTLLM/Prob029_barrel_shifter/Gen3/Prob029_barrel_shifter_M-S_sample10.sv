module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    always @(*) begin
        // Initial value
        out = in;
        
        // Stage 1: 4-bit shift if ctrl[2] is set
        if (ctrl[2]) out = {out[3:0], out[7:4]};
        
        // Stage 2: 2-bit shift if ctrl[1] is set
        if (ctrl[1]) out = {out[1:0], out[7:2]};
        
        // Stage 3: 1-bit shift if ctrl[0] is set
        if (ctrl[0]) out = {out[0], out[7:1]};
    end
endmodule