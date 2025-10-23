module TopModule(
    input [1023:0] in,  // 1024-bit input vector
    input [7:0] sel,    // 8-bit select signal
    output [3:0] out    // 4-bit output
);

always @(*) begin
    case (sel)
        256'd0: out = in[3:0];
        256'd1: out = in[7:4];
        256'd2: out = in[11:8];
        //...
        256'd255: out = in[1023:1020];
        default: out = 4'd0;  // default case, not reachable in this implementation
    endcase
end

endmodule