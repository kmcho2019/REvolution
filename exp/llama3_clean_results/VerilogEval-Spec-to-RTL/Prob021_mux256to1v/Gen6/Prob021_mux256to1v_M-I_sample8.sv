module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Directly select the desired 4-bit input from the 1024-bit input vector
always @(*) begin
    case (sel)
        8'd0: out = in[3:0];
        8'd1: out = in[7:4];
        8'd2: out = in[11:8];
        // ... and so on for all 256 cases
        8'd255: out = in[1023:1020];
        default: out = 4'd0; // default value in case of invalid selector
    endcase
end

endmodule