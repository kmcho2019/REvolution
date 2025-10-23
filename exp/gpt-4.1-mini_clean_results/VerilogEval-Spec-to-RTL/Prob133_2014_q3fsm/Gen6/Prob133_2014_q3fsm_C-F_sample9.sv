module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0; // Wait for s=1
    localparam B = 1'b1; // Sampling w over 3 cycles

    reg state, next_state;
    reg [1:0] cycle_cnt;  // counts 0..2 (3 cycles)
    reg [1:0] w_count;    // counts number of w=1 in current window

    // Sequential logic: state, counters, output z
    always @(posedge clk) begin
        if (reset) begin
            state     <= A;
            cycle_cnt <= 2'b00;
            w_count   <= 2'b00;
            z         <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // In state A, stay idle, clear counters and output
                    cycle_cnt <= 2'b00;
                    w_count   <= 2'b00;
                    z         <= 1'b0;
                end

                B: begin
                    if (cycle_cnt < 2'd2) begin
                        // Sampling cycles 0 and 1
                        cycle_cnt <= cycle_cnt + 1'b1;
                        w_count   <= w_count + w;
                        z         <= 1'b0; // z asserted only after 3rd sample
                    end else begin
                        // cycle_cnt == 2: third sample cycle, sample w now
                        // Output z immediately here per Mealy style
                        z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;

                        // Reset counters for next window
                        cycle_cnt <= 2'b00;
                        w_count   <= 2'b00;
                    end
                end

                default: begin
                    // Safe fallback
                    state     <= A;
                    cycle_cnt <= 2'b00;
                    w_count   <= 2'b00;
                    z         <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            A:  next_state = (s == 1'b1) ? B : A;
            B:  next_state = B;
            default: next_state = A;
        endcase
    end

endmodule