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

    // Counters for cycles and w=1 occurrences
    reg [1:0] cycle_count;
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
                    z <= 1'b0;
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'b00;
                        w_count <= 2'b00;
                    end
                end
                B: begin
                    if (cycle_count < 2'b10) begin
                        cycle_count <= cycle_count + 1'b1;
                        if (w) w_count <= w_count + 1'b1;
                    end
                    else begin
                        // Final cycle of the 3-cycle window
                        if (w) w_count <= w_count + 1'b1;
                        z <= (w_count == 2'b10); // Check if exactly two w=1
                        // Reset for next 3-cycle window
                        cycle_count <= 2'b00;
                        w_count <= 2'b00;
                    end
                end
            endcase
        end
    end

endmodule