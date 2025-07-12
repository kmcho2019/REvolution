module TopModule (
    input  wire in,
    output reg  out
);
    always @(*) begin
        out = (in == 1'b0) ? 1'b1 : 1'b0;
    end
endmodule