module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: only two states needed
    localparam A = 1'b0; // wait for s=1
    localparam B = 1'b1; // sampling w for 3 cycles

    reg state, next_state;
    reg [1:0] cycle_count;   // counts 0,1,2 for the 3 sampling cycles
    reg [1:0] w_ones_count;  // counts number of w=1 in current 3-cycle window

    // Next state logic
    always @(*) begin
        case(state)
            A: next_state = s ? B : A;
            B: next_state = B; // remain in B continuously
            default: next_state = A;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state        <= A;
            cycle_count  <= 2'd0;
            w_ones_count <= 2'd0;
            z            <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    cycle_count  <= 2'd0;
                    w_ones_count <= 2'd0;
                    z            <= 1'b0;
                end

                B: begin
                    if(cycle_count < 2) begin
                        // increment cycle counter and accumulate w count
                        cycle_count  <= cycle_count + 1;
                        w_ones_count <= w_ones_count + w;
                        z            <= 1'b0;
                    end else begin
                        // On the third sample (cycle_count=2), evaluate z output
                        // cycle_count reset to zero, w_ones_count reset after evaluation
                        // Because counting w for cycles 0,1,2, total three samples

                        // Add current w to w_ones_count for total count over 3 cycles
                        // w_ones_count + w can be 0..3, stored in 2 bits, but max 3 fits 2 bits with overflow.
                        // To avoid overflow, widen addition to 3 bits
                        reg [2:0] total_ones;
                        total_ones = w_ones_count + w;

                        z <= (total_ones == 3'd2) ? 1'b1 : 1'b0;

                        cycle_count  <= 2'd0;
                        w_ones_count <= 2'd0;
                    end
                end

                default: begin
                    cycle_count  <= 2'd0;
                    w_ones_count <= 2'd0;
                    z            <= 1'b0;
                end
            endcase
        end
    end

endmodule