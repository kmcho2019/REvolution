module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0 = OFF, 1 = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;  // Async reset to OFF
    end else case (state)
        1'b0: state <= j;  // OFF state transitions
        1'b1: state <= ~k; // ON state transitions
    endcase
end

assign out = state;

endmodule