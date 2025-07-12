module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Cycle counter for 3-cycle window (0-2)
    reg [1:0] cycle_cnt;
    // Shift register for last 3 w values
    reg [2:0] w_history;
    // Output register
    reg z_reg;

    assign z = z_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b0;
            w_history <= 3'b0;
            z_reg <= 1'b0;
        end else begin
            z_reg <= 1'b0; // Default z to 0
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_cnt <= 2'b0;
                        w_history <= 3'b0;
                    end
                end
                B: begin
                    // Store current w value
                    w_history <= {w_history[1:0], w};
                    
                    // Update cycle counter
                    if (cycle_cnt == 2'b10) begin
                        cycle_cnt <= 2'b0;
                        // Check for exactly two 1's in the window
                        if ($countones(w_history) == 2) begin
                            z_reg <= 1'b1;
                        end
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end
                end
            endcase
        end
    end

endmodule