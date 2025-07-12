module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    case ({j, k})
        2'b00: Q <= Q;           // hold state
        2'b01: Q <= 1'b0;        // reset
        2'b10: Q <= 1'b1;        // set
        2'b11: Q <= ~Q;          // toggle
        default: Q <= Q;         // safe default (should never occur)
    endcase
end

endmodule