module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0,
               B = 1'b1;

    reg state, next_state;

    // Counters for cycles and w count in B
    reg [1:0] cycle_count; // counts 0 to 2 (3 cycles)
    reg [1:0] w_count;     // counts how many times w=1 in these 3 cycles

    // Sequential logic for state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // In A, counters and z are zeroed
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
                B: begin
                    // count w and cycle_count
                    if (cycle_count < 2) begin
                        cycle_count <= cycle_count + 1'b1;
                        w_count <= w_count + w; // add 1 if w=1 else 0
                        z <= 1'b0; // no z output during counting cycles
                    end else begin
                        // This is the 3rd cycle (count = 2)
                        // add this w to w_count
                        // then output z in this cycle based on total count
                        // Then reset counters for next 3 cycles

                        // total w count = w_count + w
                        if ((w_count + w) == 2)
                            z <= 1'b1;
                        else
                            z <= 1'b0;

                        cycle_count <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // In B, remain in B forever (per description)
                next_state = B;
            end
            default: next_state = A;
        endcase
    end

endmodule