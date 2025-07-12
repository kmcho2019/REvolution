module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    case ({L, E})
        2'b01: Q <= R;
        2'b10: Q <= w;
        2'b11: Q <= R;
        default: Q <= Q;
    endcase
end

endmodule