module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // State A = 0, State B = 1, with internal states handled by counters
reg [1:0] count_w; // Counter for w = 1 within the 3-cycle window
reg [1:0] cycle_count; // Counter for the current cycle within the 3-cycle window
reg z_reg; // Register to hold the output z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset to state A
        count_w <= 0;
        cycle_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    count_w <= 0;
                    cycle_count <= 1; // Start the 3-cycle count
                end
            end
            1: begin // State B
                if (w) begin
                    count_w <= count_w + 1; // Increment count if w = 1
                end
                cycle_count <= cycle_count + 1; // Increment cycle count
                if (cycle_count == 3) begin // End of 3-cycle window
                    if (count_w == 2) begin // Check if exactly two w = 1
                        z_reg <= 1;
                    end else begin
                        z_reg <= 0;
                    end
                    count_w <= 0; // Reset count for next window
                    cycle_count <= 1; // Reset cycle count
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule