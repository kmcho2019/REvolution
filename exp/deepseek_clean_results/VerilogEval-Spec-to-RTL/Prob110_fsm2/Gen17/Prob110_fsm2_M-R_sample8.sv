module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0 = OFF, 1 = ON
wire next_state;

// State transition logic
assign next_state = (state == 1'b0) ? j : ~k;

// State register with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;  // Async reset to OFF
    end else begin
        state <= next_state;
    end
end

// Output assignment
assign out = state;

endmodule