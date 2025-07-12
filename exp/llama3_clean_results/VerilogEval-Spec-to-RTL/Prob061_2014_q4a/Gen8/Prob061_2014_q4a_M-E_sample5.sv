module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg enable_clock;

always @(posedge clk) begin
    if (enable_clock) begin
        case ({L, E})
            2'b01: Q <= w;
            2'b10: Q <= R;
            default: Q <= Q;
        endcase
    end
end

always @(*) begin
    case ({L, E})
        2'b00: enable_clock = 1'b0;
        default: enable_clock = 1'b1;
    endcase
end

endmodule