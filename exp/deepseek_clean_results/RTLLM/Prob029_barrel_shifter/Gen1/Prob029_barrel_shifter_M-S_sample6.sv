module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    always @(*) begin
        // Stage 1: Shift by 4 bits if ctrl[2] is set
        out = ctrl[2] ? {in[3:0], in[7:4]} : in;
        
        // Stage 2: Shift by 2 bits if ctrl[1] is set
        out = ctrl[1] ? {out[5:0], out[7:6]} : out;
        
        // Stage 3: Shift by 1 bit if ctrl[0] is set
        out = ctrl[0] ? {out[6:0], out[7]} : out;
    end

endmodule