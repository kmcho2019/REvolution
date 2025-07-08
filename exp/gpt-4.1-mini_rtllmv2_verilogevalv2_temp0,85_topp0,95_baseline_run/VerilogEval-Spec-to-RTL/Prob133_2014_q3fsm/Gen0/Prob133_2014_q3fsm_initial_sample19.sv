module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // States
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [1:0] cycle_count; // Counts from 0 to 2 for the 3 cycles
    reg [1:0] w_count;     // Counts number of times w=1 in 3 cycles
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0; // z=0 in state A always
                    if (s == 1'b1) begin
                        state <= B;
                        cycle_count <= 2'd0;
                        w_count <= w ? 2'd1 : 2'd0;
                        z <= 1'b0;
                    end
                end
                B: begin
                    if (cycle_count < 2) begin
                        cycle_count <= cycle_count + 1;
                        w_count <= w_count + (w ? 1'b1 : 1'b0);
                        z <= 1'b0;
                    end else begin
                        // After 3 cycles
                        // cycle_count == 2 means 3 cycles completed (0,1,2)
                        // Check if w_count + current w equals 2
                        // Because we have recorded w_count for previous 2 cycles,
                        // we add current w in this cycle to w_count for total count
                        if (w_count + (w ? 1'b1 : 1'b0) == 2) begin
                            z <= 1'b1;
                        end else begin
                            z <= 1'b0;
                        end
                        // Start new 3 cycle count
                        cycle_count <= 2'd0;
                        w_count <= w ? 2'd1 : 2'd0;
                    end
                end
                default: begin
                    state <= A;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule