module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt;  // 0 to 2, counts cycles in B
    reg [1:0] w_count;    // counts number of w=1 in current 3-cycle window

    // State register and next_state logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            A: next_state = (s == 1'b1) ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Counters and output logic
    always @(posedge clk) begin
        if (reset) begin
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    // Reset counters and output in A
                    cycle_cnt <= 2'b00;
                    w_count <= 2'b00;
                    z <= 1'b0;
                end

                B: begin
                    if (cycle_cnt < 2) begin
                        // Increment cycle counter
                        cycle_cnt <= cycle_cnt + 1'b1;
                        // Increment w_count only if w=1 to reduce toggling
                        if (w)
                            w_count <= w_count + 1'b1;
                        // Keep z low during sampling cycles
                        z <= 1'b0;
                    end else begin
                        // On third sample cycle:
                        // Calculate total w count (w_count + current w)
                        // Output z accordingly
                        z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                        // Reset counters for next window
                        cycle_cnt <= 2'b00;
                        w_count <= 2'b00;
                    end
                end

                default: begin
                    cycle_cnt <= 2'b00;
                    w_count <= 2'b00;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule