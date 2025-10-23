module TopModule(
    input  [255:0] in,  // 256 bits
    input  [7:0] sel,  // 8 bits
    output out
);

always @(in, sel) begin
    case (sel)
        8'd0:   out = in[0];
        8'd1:   out = in[1];
        8'd2:   out = in[2];
        // ... add 253 more lines like the above
        8'd255: out = in[255];
        default: out = 1'b0;  // or out = in[0]; if no default is desired
    endcase
end

endmodule