module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg state;  // 0=A, 1=B
reg [2:0] w_history;
reg [1:0] counter;
reg z_reg;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;  // State A
        counter <= 2'b0;
    end else begin
        case (state)
            1'b0: begin
                state <= s ? 1'b1 : 1'b0;  // Move to B if s=1
                counter <= 2'b0;
            end
            1'b1: begin
                counter <= (counter == 2'd2) ? 2'd0 : counter + 1;
            end
        endcase
    end
end

// Shift register for w history
always @(posedge clk) begin
    if (reset) begin
        w_history <= 3'b0;
    end else if (state && (counter != 2'd2)) begin  // Only update first two cycles
        w_history <= {w_history[1:0], w};
    end
end

// z output with proper timing
always @(posedge clk) begin
    if (reset) begin
        z_reg <= 1'b0;
    end else if (state && (counter == 2'd2)) begin
        z_reg <= (w_history[0] + w_history[1] + w) == 2;  // Current w is third sample
    end
end

assign z = z_reg;

endmodule