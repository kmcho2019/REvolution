module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;

    reg [1:0] state, next_state;
    reg [1:0] cycle_count;  // counts from 0 to 2 (three cycles)
    reg [1:0] w_count;      // counts how many times w=1 in 3 cycles

    // State transition and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            case(state)
                A: begin
                    z <= 0;
                    cycle_count <= 0;
                    w_count <= 0;
                end
                B: begin
                    // Increment cycle count and update w count if w=1
                    cycle_count <= cycle_count + 1;
                    if (w)
                        w_count <= w_count + 1;
                    else
                        w_count <= w_count;
                    z <= 0;
                end
                C: begin
                    // Output z based on w_count == 2
                    z <= (w_count == 2) ? 1'b1 : 1'b0;
                    // Reset counters for next cycle collection
                    cycle_count <= 0;
                    w_count <= 0;
                end
                default: begin
                    z <= 0;
                    cycle_count <= 0;
                    w_count <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (cycle_count == 2) // after collecting 3 samples (0,1,2)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                // After outputting z, go back to B to start next 3 cycles
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

endmodule