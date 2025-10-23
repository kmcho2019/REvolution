module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0 - A, 1 - B
reg [2:0] counter; // Counter for 3 clock cycles in state B
reg [1:0] w_count; // Counter for w=1 occurrences in 3 cycles
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to state A
        counter <= 3'b000; // Reset counter
        w_count <= 2'b00; // Reset w_count
        z_reg <= 1'b0; // Reset z
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Move to state B
                    counter <= 3'b001; // Start counter
                    w_count <= 2'b00; // Reset w_count
                end
            end
            1: begin // State B
                if(counter < 3'b100) begin // Still within 3 cycles
                    counter <= counter + 1; // Increment counter
                    if(w) begin
                        w_count <= w_count + 1; // Increment w_count if w=1
                    end
                end else begin // 3 cycles completed
                    counter <= 3'b001; // Reset counter for next 3 cycles
                    if(w_count == 2'b10) begin // Exactly two w=1 in 3 cycles
                        z_reg <= 1'b1; // Set z to 1
                    end else begin
                        z_reg <= 1'b0; // Otherwise, z remains 0
                    end
                    if(w) begin
                        w_count <= 1; // New cycle, w_count starts with current w value
                    end else begin
                        w_count <= 0; // New cycle, w_count starts at 0
                    end
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule