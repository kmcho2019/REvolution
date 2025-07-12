module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    reg [1:0] cycle_in_b;      // counts number of cycles since entering B (0..2)
    reg [2:0] w_shift;         // shift register holding last 3 w samples in B

    // Function to count bits set in 3-bit vector
    function [1:0] count_ones;
        input [2:0] bits;
        begin
            count_ones = bits[0] + bits[1] + bits[2];
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_in_b <= 2'd0;
            w_shift <= 3'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle_in_b <= 2'd0;
                    w_shift <= 3'd0;
                    if (s == 1'b1) begin
                        state <= B;
                        cycle_in_b <= 2'd0;  // starting counting cycles in B
                        w_shift <= {w_shift[1:0], w}; // shift in current w
                        z <= 1'b0;
                    end else begin
                        state <= A;
                    end
                end

                B: begin
                    // Shift in new w sample each cycle
                    w_shift <= {w_shift[1:0], w};

                    if (cycle_in_b < 2)
                        cycle_in_b <= cycle_in_b + 1;
                    // else cycle_in_b stays at 2 (3 or more cycles elapsed)

                    // Output z only if at least 3 samples collected (cycle_in_b >= 2)
                    if (cycle_in_b >= 2) begin
                        // Count ones in last 3 w samples
                        // Set z=1 if exactly two of them are 1
                        z <= (count_ones(w_shift) == 2);
                    end else begin
                        // Before having 3 samples, z=0
                        z <= 1'b0;
                    end

                    // stay in B state indefinitely
                    state <= B;
                end

                default: begin
                    state <= A;
                    cycle_in_b <= 2'd0;
                    w_shift <= 3'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule