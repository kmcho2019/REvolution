module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

integer i;
reg [3:0] out;

always @(*) begin
    case (sel)
        8'h00: out = in[3:0];
        8'h01: out = in[7:4];
        8'h02: out = in[11:8];
        //... (generate the remaining 253 cases)
        8'hFF: out = in[1023:1020];
        default: out = 4'b0;
    endcase
end

endmodule