module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output reg     out
);

always @(*) begin
    case (sel)
        8'd0: out = in[0];
        8'd1: out = in[1];
        8'd2: out = in[2];
        // ... (all cases up to 255)
        8'd255: out = in[255];
        default: out = 1'b0; // Covers all cases explicitly
    endcase
end

endmodule