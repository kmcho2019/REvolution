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

    // Next state logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window tracking with one-hot encoding
    reg [2:0] pos_cnt;  // one-hot: 001, 010, 100
    reg [1:0] w_count;  // counts number of 1's in current window
    wire window_done = pos_cnt[2];  // indicates last cycle of window

    // Registered evaluation signals
    reg eval_next;
    reg [1:0] saved_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 3'b001;
            w_count <= 2'b0;
            eval_next <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update position counter (one-hot rotation)
                pos_cnt <= {pos_cnt[1:0], pos_cnt[2]};
                
                // Update w count only when needed
                if (!pos_cnt[2]) begin  // first two cycles of window
                    w_count <= w_count + w;
                end else begin  // last cycle of window
                    // Save count for next cycle evaluation
                    saved_count <= w_count + w;
                    eval_next <= 1'b1;
                    // Reset for next window
                    w_count <= 2'b0;
                end
            end else begin
                // Reset counters in state A
                pos_cnt <= 3'b001;
                w_count <= 2'b0;
                eval_next <= 1'b0;
            end
            
            // Output evaluation (registered)
            z <= eval_next ? (saved_count == 2'd2) : 1'b0;
            eval_next <= 1'b0;  // clear after use
        end
    end

endmodule