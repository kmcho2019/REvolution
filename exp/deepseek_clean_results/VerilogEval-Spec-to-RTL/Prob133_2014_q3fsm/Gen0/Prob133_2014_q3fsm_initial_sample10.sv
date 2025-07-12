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

    // Counter for 3 cycles (0,1,2)
    reg [1:0] cycle_count;
    // Counter for number of w=1 in current window
    reg [1:0] w_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'b00;
                        w_count <= 2'b00;
                    end
                    z <= 1'b0;
                end
                B: begin
                    // Count w=1 in current cycle
                    if (w) w_count <= w_count + 1'b1;

                    // Update cycle counter
                    if (cycle_count == 2'b10) begin
                        // End of 3-cycle window
                        cycle_count <= 2'b00;
                        z <= (w_count == 2'b10); // Set z if exactly two w=1
                        w_count <= 2'b00; // Reset for next window
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule