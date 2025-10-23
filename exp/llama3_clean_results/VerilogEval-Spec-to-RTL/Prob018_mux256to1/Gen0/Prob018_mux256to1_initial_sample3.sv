module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

always @(*) begin
    case(sel)
        8'b00000000: out = in[0];
        8'b00000001: out = in[1];
        8'b00000010: out = in[2];
        8'b00000011: out = in[3];
        // ... (all other cases)
        8'b11111110: out = in[254];
        8'b11111111: out = in[255];
        default: out = 1'b0; // default case
    endcase
end

endmodule