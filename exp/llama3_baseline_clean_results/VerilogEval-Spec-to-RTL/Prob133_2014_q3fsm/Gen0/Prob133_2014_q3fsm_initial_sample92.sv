module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 2-bit state register
reg [1:0] count_w; // Counter for w = 1
reg [1:0] count_clk; // Counter for clock cycles
reg z_reg; // Register for output z

// Initialize state and counters
initial begin
    state = 2'b00; // State A
    count_w = 2'b00;
    count_clk = 2'b00;
    z_reg = 1'b0;
end

// State transition and counter update
always @(posedge clk) begin
    if (reset) begin
        state = 2'b00; // Reset to state A
        count_w = 2'b00;
        count_clk = 2'b00;
        z_reg = 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state = 2'b01; // Transition to state B
                    count_w = 2'b00;
                    count_clk = 2'b01;
                end
            end
            2'b01: begin // State B
                if (w) begin
                    count_w = count_w + 1; // Increment w counter
                end
                count_clk = count_clk + 1; // Increment clock counter
                if (count_clk == 3) begin
                    state = 2'b10; // Transition to state C
                    z_reg = (count_w == 2) ? 1'b1 : 1'b0;
                end
            end
            2'b10: begin // State C
                state = 2'b01; // Transition back to state B
                count_w = 2'b00;
                count_clk = 2'b01;
            end
        endcase
    end
end

// Assign output
assign z = z_reg;

endmodule