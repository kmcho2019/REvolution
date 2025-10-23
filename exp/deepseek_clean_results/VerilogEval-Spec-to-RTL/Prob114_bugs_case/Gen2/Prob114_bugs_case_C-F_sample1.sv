module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

always @(*) begin
    case (code)
        8'h45: {out, valid} = {0, 1'b1};
        8'h16: {out, valid} = {1, 1'b1};
        8'h1e: {out, valid} = {2, 1'b1};
        8'h26: {out, valid} = {3, 1'b1};
        8'h25: {out, valid} = {4, 1'b1};
        8'h2e: {out, valid} = {5, 1'b1};
        8'h36: {out, valid} = {6, 1'b1};
        8'h3d: {out, valid} = {7, 1'b1};
        8'h3e: {out, valid} = {8, 1'b1};
        8'h46: {out, valid} = {9, 1'b1};
        default: {out, valid} = {0, 1'b0};
    endcase
end

endmodule