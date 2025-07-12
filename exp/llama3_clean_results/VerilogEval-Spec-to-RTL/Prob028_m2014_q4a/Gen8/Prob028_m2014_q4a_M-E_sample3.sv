module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d or ena) begin
    case (ena)
        1'b1: q <= d; // When ena is high, q follows d
        default: ; // Implicitly retains the previous value of q when ena is low
    endcase
end

endmodule