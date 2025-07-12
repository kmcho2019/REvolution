module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking and counting
    reg [1:0] cnt;
    reg [1:0] ones;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt <= 2'b0;
            ones <= 2'b0;
            z <= 1'b0;
        end else begin
            // Default output
            z <= 1'b0;

            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cnt <= 2'b0;
                        ones <= 2'b0;
                    end
                end
                B: begin
                    if (cnt == 2'b10) begin
                        // Evaluate at end of window
                        z <= (ones + w) == 2'd2;
                        cnt <= 2'b0;
                        ones <= 2'b0;
                    end else begin
                        // Count '1's during window
                        cnt <= cnt + 1'b1;
                        ones <= ones + w;
                    end
                end
            endcase
        end
    end

endmodule