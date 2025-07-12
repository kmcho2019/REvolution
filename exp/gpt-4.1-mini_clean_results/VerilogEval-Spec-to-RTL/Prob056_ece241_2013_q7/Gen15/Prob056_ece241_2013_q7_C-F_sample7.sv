module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg nextQ;

always @(*) begin
    case ({j, k})
        2'b00: nextQ = Q;       // Hold
        2'b01: nextQ = 1'b0;    // Reset
        2'b10: nextQ = 1'b1;    // Set
        2'b11: nextQ = ~Q;      // Toggle
        default: nextQ = Q;     // Safety fallback
    endcase
end

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule