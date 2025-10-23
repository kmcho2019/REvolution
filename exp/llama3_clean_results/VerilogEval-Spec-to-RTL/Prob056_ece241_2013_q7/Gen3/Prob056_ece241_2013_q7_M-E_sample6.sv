module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg Qold;

always @(posedge clk) begin
    case ({j, k, Q})
        3'b000: Q <= Q;
        3'b001: Q <= 0;
        3'b010: Q <= 1;
        3'b011: Q <= ~Q;
        3'b100: Q <= 1;
        3'b101: Q <= ~Q;
        3'b110: Q <= 0;
        3'b111: Q <= ~Q;
        default: Q <= Q;
    endcase
end

endmodule