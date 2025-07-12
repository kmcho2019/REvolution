module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] counter; // Counter for the 3 clock cycles
reg [1:0] w_counter; // Counter for the number of times w is 1
reg state; // State of the FSM (A or B)
reg z_reg; // Registered output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_counter <= 0;
        z_reg <= 0;
    end else if (!state) begin // State A
        if (s) begin
            state <= 1; // Move to state B
        end
    end else begin // State B
        if (counter < 3) begin
            if (w) begin
                w_counter <= w_counter + 1;
            end
            counter <= counter + 1;
        end else begin // After 3 clock cycles
            z_reg <= (w_counter == 2); // Set z to 1 if w was 1 exactly twice
            counter <= 0; // Reset counters for the next set of cycles
            w_counter <= 0;
        end
    end
end

assign z = z_reg;

endmodule