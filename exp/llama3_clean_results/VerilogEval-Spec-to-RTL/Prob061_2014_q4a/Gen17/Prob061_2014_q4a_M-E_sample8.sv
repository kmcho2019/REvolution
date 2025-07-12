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
        2'b01: Q <= R; // Load when L is high and E is low
        2'b10: Q <= w; // Shift when L is low and E is high
        default: Q <= Q; // Hold current value otherwise
    endcase
end

endmodule