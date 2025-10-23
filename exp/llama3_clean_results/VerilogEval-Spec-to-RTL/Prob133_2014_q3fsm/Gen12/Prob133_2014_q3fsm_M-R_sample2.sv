module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // State variable: 0 for state A, 1-3 for state B
reg [1:0] w_count; // Counter for w = 1
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= 0;
        w_count <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // State A
                if(s) begin
                    // Transition to state B
                    state <= 1;
                    w_count <= 0;
                end
            end
            1, 2, 3: begin
                // State B
                if(w) begin
                    // Increment w_count if w = 1
                    w_count <= w_count + 1;
                end
                // Transition to next state
                if(state == 3) begin
                    state <= 0;
                    if(w_count == 2) begin
                        // Set z_reg to 1 if w_count = 2
                        z_reg <= 1;
                    end
                    else begin
                        // Set z_reg to 0 if w_count != 2
                        z_reg <= 0;
                    end
                end
                else begin
                    state <= state + 1;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule