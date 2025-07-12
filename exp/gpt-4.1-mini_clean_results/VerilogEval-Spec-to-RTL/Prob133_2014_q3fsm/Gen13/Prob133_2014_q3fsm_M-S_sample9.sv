module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    localparam A = 1'b0, B = 1'b1;
    reg state;
    reg [1:0] cycle;       // counts 0..2
    reg [2:0] w_shift;     // shift register storing last 3 w inputs
    reg z_pending;         // flag to delay z assertion by 1 cycle

    // Count number of 1s in w_shift
    wire [1:0] ones_count = w_shift[0] + w_shift[1] + w_shift[2];

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle <= 2'd0;
            w_shift <= 3'd0;
            z <= 1'b0;
            z_pending <= 1'b0;
        end else begin
            z <= 1'b0;           // default output zero unless set below
            case(state)
                A: begin
                    cycle <= 2'd0;
                    w_shift <= 3'd0;
                    z_pending <= 1'b0;
                    if (s)
                        state <= B;
                end
                B: begin
                    w_shift <= {w_shift[1:0], w};  // shift in new w
                    if (cycle == 2) begin
                        // At cycle 2, set z_pending if exactly two ones in w_shift+w
                        // Note: w_shift currently holds previous 2 inputs; the third is w input just shifted in
                        // The new w was shifted in, so w_shift contains 3 samples now.
                        z_pending <= (ones_count == 2);
                        cycle <= 2'd0;
                    end else begin
                        cycle <= cycle + 1;
                        z_pending <= 1'b0;
                    end

                    // Output z one cycle after counting
                    if (z_pending)
                        z <= 1'b1;
                end
            endcase
        end
    end

endmodule