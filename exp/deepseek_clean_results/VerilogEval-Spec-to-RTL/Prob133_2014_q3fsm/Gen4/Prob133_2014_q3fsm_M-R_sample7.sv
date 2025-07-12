module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state;  // 0=A, 1=B
reg [2:0] w_history;
reg z_reg;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;  // State A
    end else begin
        case (state)
            1'b0: state <= s ? 1'b1 : 1'b0;  // Move to B if s=1
            1'b1: state <= 1'b1;             // Stay in B
        endcase
    end
end

// Shift register for w history
always @(posedge clk) begin
    if (reset) begin
        w_history <= 3'b0;
    end else if (state) begin  // Only update in state B
        w_history <= {w_history[1:0], w};
    end
end

// z output with 1-cycle delay
always @(posedge clk) begin
    if (reset) begin
        z_reg <= 1'b0;
    end else begin
        z_reg <= (w_history[0] + w_history[1] + w_history[2]) == 2;
    end
end

assign z = z_reg;

endmodule