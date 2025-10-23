module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // State variable, 2 states: A (0) and B (1,2,3)
reg [1:0] count_w; // Counter for w highs in 3 clock cycles
reg [1:0] count_cycle; // Counter for clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state to A
        count_w <= 0;
        count_cycle <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Transition to state B
                end
            end
            1: begin // State B, first cycle
                state <= 2;
                count_cycle <= 1;
                if (w) begin
                    count_w <= 1;
                end else begin
                    count_w <= 0;
                end
            end
            2: begin // State B, second cycle
                state <= 3;
                count_cycle <= 2;
                if (w) begin
                    count_w <= count_w + 1;
                end
            end
            3: begin // State B, third cycle
                if (w) begin
                    count_w <= count_w + 1;
                end
                if (count_w == 2) begin
                    z <= 1; // Set z high if w was high exactly twice
                end else begin
                    z <= 0;
                end
                state <= 1; // Transition back to first cycle of state B
                count_cycle <= 0;
                count_w <= 0;
            end
        endcase
    end
end

endmodule