module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State definitions
    reg state;        // 0=A, 1=B
    reg [2:0] w_window;  // Shift register for last 3 w values
    reg [1:0] fill_count; // Tracks how many bits are valid in w_window

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;      // State A
            w_window <= 0;
            fill_count <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin  // State A
                    z <= 0;
                    if (s) begin
                        state <= 1;  // Move to state B
                        w_window <= 0;
                        fill_count <= 0;
                    end
                end
                1: begin  // State B
                    // Shift in new w value
                    w_window <= {w_window[1:0], w};
                    
                    // Update fill count (saturates at 3)
                    if (fill_count < 3)
                        fill_count <= fill_count + 1;

                    // Evaluate when window is full (every 3 cycles)
                    if (fill_count == 3) begin
                        // Count number of 1's in window
                        case (w_window)
                            3'b011, 3'b101, 3'b110: z <= 1;
                            default: z <= 0;
                        endcase
                    end else begin
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule