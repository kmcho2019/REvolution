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
    // Counter for cycles in state B
    reg [1:0] cycle_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b0;
            cycle_count <= 2'b0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    if (s) begin
                        state <= B;
                        w_history <= {w_history[1:0], w};
                        cycle_count <= 2'b1;
                    end
                end
                B: begin
                    if (cycle_count == 2'b10) begin
                        // After 3 cycles, check condition
                        z <= (w_history[0] + w_history[1] + w) == 2'd2;
                        // Reset for next 3-cycle window
                        w_history <= 3'b0;
                        cycle_count <= 2'b0;
                    end else begin
                        // Still counting
                        z <= 1'b0;
                        w_history <= {w_history[1:0], w};
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule