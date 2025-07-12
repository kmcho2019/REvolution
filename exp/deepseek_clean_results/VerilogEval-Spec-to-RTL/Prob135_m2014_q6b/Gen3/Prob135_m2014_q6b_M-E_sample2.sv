module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

reg y1_next;

always @(*) begin
    case (y)
        3'b000: y1_next = w ? 1'b0 : 1'b0; // A: stays A or goes to B (y[1] stays 0)
        3'b001: y1_next = w ? 1'b1 : 1'b1; // B: goes to D (1) or C (1)
        3'b010: y1_next = w ? 1'b1 : 1'b0; // C: goes to D (1) or E (0)
        3'b011: y1_next = w ? 1'b0 : 1'b0; // D: goes to A (0) or F (0)
        3'b100: y1_next = w ? 1'b1 : 1'b0; // E: goes to D (1) or stays E (0)
        3'b101: y1_next = w ? 1'b1 : 1'b1; // F: goes to D (1) or C (1)
        default: y1_next = 1'b0;
    endcase
end

assign Y1 = y[1];

endmodule