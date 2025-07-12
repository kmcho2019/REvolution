module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;
    reg [2:0] w_window;

    // Count number of 1s in current window
    wire [1:0] ones_count = w_window[0] + w_window[1] + w_window[2];

    // Output is high when in state B, at end of window, and exactly two 1s
    assign z = (state == B) && (cycle_count == 2'b10) && (ones_count == 2'd2);

    // State transition and window management
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_window <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        // Initialize window with current w and two zeros
                        w_window <= {2'b00, w};
                        cycle_count <= 2'b01;
                    end
                end
                B: begin
                    // Shift in new w value
                    w_window <= {w_window[1:0], w};
                    
                    // Update cycle counter (modulo 3)
                    if (cycle_count == 2'b10)
                        cycle_count <= 2'b00;
                    else
                        cycle_count <= cycle_count + 1;
                end
            endcase
        end
    end

endmodule