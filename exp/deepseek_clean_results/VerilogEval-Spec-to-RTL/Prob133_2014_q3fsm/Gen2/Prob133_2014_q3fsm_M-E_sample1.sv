module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for last 3 w values
    reg [2:0] w_history;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    w_history <= 3'b000;
                    if (s) begin
                        state <= B;
                    end
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};
                    
                    // Check if we have 3 samples (any bit set in position 2)
                    if (w_history[2]) begin
                        // Count number of 1's in the history
                        case (w_history)
                            3'b011, 3'b101, 3'b110: z <= 1'b1;
                            default: z <= 1'b0;
                        endcase
                        // Clear history for next window
                        w_history <= 3'b000;
                    end else begin
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule