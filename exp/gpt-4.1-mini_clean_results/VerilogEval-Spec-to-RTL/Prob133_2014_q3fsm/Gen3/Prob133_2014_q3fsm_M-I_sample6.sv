module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: minimal 2-bit FSM
    localparam [1:0]
        A  = 2'd0,  // waiting for s=1
        B0 = 2'd1,  // 1st sample cycle of w
        B1 = 2'd2,  // 2nd sample cycle of w
        B2 = 2'd3;  // 3rd sample cycle of w

    reg [1:0] state, next_state;
    reg [1:0] count;   // count of w=1 in current sample window (0 to 3)
    reg       z_reg;   // output register to assert z one cycle after sampling

    // Sequential block: state, count, and output register updates
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            z_reg <= 1'b0;
            z     <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    // In A, no counting, output zero
                    count <= 2'd0;
                    z_reg <= 1'b0;  // ensure z_reg cleared on reset or waiting
                    z     <= 1'b0;
                end

                B0: begin
                    // Start a new sample window: reset count and accumulate w
                    count <= (w ? 2'd1 : 2'd0);
                    // Output z_reg from previous window in this cycle
                    z     <= z_reg;
                end

                B1: begin
                    // Accumulate w count
                    count <= count + (w ? 2'd1 : 2'd0);
                    // Output zero during sampling cycles
                    z     <= 1'b0;
                end

                B2: begin
                    // Accumulate final w count in this window
                    count <= count + (w ? 2'd1 : 2'd0);
                    // Output zero during sampling cycles
                    z     <= 1'b0;

                    // Update z_reg synchronously with count after all samples:
                    // This reflects the count before next cycle (in next_state)
                    // Use the sum of count + current w to get final count
                    z_reg <= ((count + (w ? 2'd1 : 2'd0)) == 2) ? 1'b1 : 1'b0;
                end

                default: begin
                    // Safety fallback
                    count <= 2'd0;
                    z_reg <= 1'b0;
                    z     <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        case (state)
            A:  next_state = (s == 1'b1) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule