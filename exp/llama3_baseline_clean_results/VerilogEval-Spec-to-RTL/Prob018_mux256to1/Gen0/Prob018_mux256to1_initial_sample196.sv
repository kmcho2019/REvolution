module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

always @(in, sel) begin
    case (sel)
        8'd0: out = in[0];
        8'd1: out = in[1];
        8'd2: out = in[2];
        // ... manually listing all 256 cases is impractical, 
        // so we use a default statement to handle all other cases
        default: out = in[sel];
    endcase
end

endmodule