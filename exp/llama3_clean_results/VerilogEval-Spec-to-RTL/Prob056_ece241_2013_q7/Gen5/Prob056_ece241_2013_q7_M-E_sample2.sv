module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    case ({j, k, Q})
        3'b000: Q <= Q;  // No change
        3'b001: Q <= Q;  // No change
        3'b010: Q <= 1'b0;
        3'b011: Q <= 1'b0;
        3'b100: Q <= 1'b1;
        3'b101: Q <= 1'b1;
        3'b110: Q <= 1'b0;
        3'b111: Q <= ~Q;
    endcase
end

endmodule