module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

reg Q_reg;

/* Truth table implementation:
 * J K | Q_next
 * ----|-------
 * 0 0 | Q_reg   (hold)
 * 0 1 | 0       (reset)
 * 1 0 | 1       (set)
 * 1 1 | ~Q_reg  (toggle)
 */
wire Q_next = (j & ~k) |        // Set case
              (~j & k) ? 1'b0 : // Reset case
              (j & k) ? ~Q_reg : // Toggle case
              Q_reg;            // Hold case

always @(posedge clk) begin
    Q_reg <= Q_next;
end

assign Q = Q_reg;

endmodule