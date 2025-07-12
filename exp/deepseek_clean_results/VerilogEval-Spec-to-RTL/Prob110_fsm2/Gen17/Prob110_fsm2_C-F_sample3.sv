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
    end else begin
        case (state)
            1'b0: state <= j;  // OFF -> ON if j=1, else stay OFF
            1'b1: state <= ~k; // ON -> OFF if k=1, else stay ON
        endcase
    end
end

assign out = state;  // Direct Moore output

endmodule