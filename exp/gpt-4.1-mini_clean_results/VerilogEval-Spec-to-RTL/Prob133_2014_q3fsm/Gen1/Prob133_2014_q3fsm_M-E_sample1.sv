module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam [1:0] A = 2'd0,
                     B = 2'd1,
                     C = 2'd2;

    reg [1:0] state;
    reg [1:0] cycle_count;  // counts 0..2 cycles in B
    reg [1:0] w_count;      // counts how many times w=1 in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    if (s == 1'b1)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    z <= 1'b0;
                    // accumulate w_count with current w
                    w_count <= w_count + w;

                    if (cycle_count == 2) begin
                        // finished counting 3 cycles (0..2)
                        cycle_count <= 2'd0;
                        state <= C; // move to output state
                    end else begin
                        cycle_count <= cycle_count + 1;
                        state <= B;
                    end
                end

                C: begin
                    // output z=1 if exactly 2 times w=1 in previous 3 cycles
                    z <= (w_count == 2);
                    // reset count for next window
                    w_count <= 2'd0;
                    cycle_count <= 2'd0;
                    // continue counting windows in state B
                    state <= B;
                end

                default: begin
                    // default to reset state
                    state <= A;
                    z <= 1'b0;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                end
            endcase
        end
    end

endmodule