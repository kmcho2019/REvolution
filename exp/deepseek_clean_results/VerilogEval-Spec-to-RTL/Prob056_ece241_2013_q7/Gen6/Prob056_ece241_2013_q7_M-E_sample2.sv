module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    case ({j, k, Q})
        3'b000: Q <= Q;  // J=0, K=0: hold
        3'b001: Q <= Q;  // J=0, K=0: hold
        3'b010: Q <= 1'b0;  // J=0, K=1: reset
        3'b011: Q <= 1'b0;  // J=0, K=1: reset
        3'b100: Q <= 1'b1;  // J=1, K=0: set
        3'b101: Q <= 1'b1;  // J=1, K=0: set
        3'b110: Q <= ~Q;  // J=1, K=1: toggle
        3'b111: Q <= ~Q;  // J=1, K=1: toggle
    endcase
end

endmodule