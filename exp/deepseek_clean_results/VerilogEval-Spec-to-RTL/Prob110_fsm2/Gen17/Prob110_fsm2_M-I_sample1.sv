module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state;  // 0 = OFF, 1 = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;  // Async reset to OFF
        out <= 1'b0;
    end else begin
        case (state)
            1'b0: state <= j ? 1'b1 : 1'b0;  // OFF -> ON if j=1, else stay
            1'b1: state <= k ? 1'b0 : 1'b1;  // ON -> OFF if k=1, else stay
        endcase
        out <= state;  // Registered output
    end
end

endmodule