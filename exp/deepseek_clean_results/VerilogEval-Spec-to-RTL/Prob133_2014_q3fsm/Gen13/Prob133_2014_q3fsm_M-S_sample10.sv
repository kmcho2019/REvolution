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

    // Window tracking
    reg [1:0] pos_cnt;    // 0-2 counter for window position
    reg [1:0] ones_cnt;   // Count of 1's in current window

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            ones_cnt <= 2'b0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) state <= B;
                    pos_cnt <= 2'b0;
                    ones_cnt <= 2'b0;
                    z <= 1'b0;
                end
                B: begin
                    // Update ones counter
                    if (w) ones_cnt <= ones_cnt + 1'b1;

                    // Update position counter and evaluate
                    if (pos_cnt == 2'b10) begin
                        pos_cnt <= 2'b0;
                        z <= (ones_cnt == 2'd2);
                        ones_cnt <= w ? 1'b1 : 1'b0;  // Start new window
                    end else begin
                        pos_cnt <= pos_cnt + 1'b1;
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule