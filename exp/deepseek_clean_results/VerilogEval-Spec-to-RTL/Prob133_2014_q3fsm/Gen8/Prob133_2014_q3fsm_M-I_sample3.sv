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

    // Window tracking
    reg [1:0] pos_cnt;
    reg [1:0] w_count;  // Stores count of 1's in current window
    reg w_last;         // Stores oldest w value to be removed

    // Registered evaluation signals
    reg eval_now;
    reg [1:0] ones_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_count <= 2'b0;
            w_last <= 1'b0;
            z <= 1'b0;
            eval_now <= 1'b0;
            ones_count <= 2'b0;
        end else begin
            state <= next_state;
            eval_now <= (state == B) && (pos_cnt == 2'b10);
            
            if (state == B) begin
                // Update position counter (modulo 3)
                pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);
                
                // Update rolling counter
                if (pos_cnt == 2'b10) begin
                    // New window starts - subtract oldest value
                    w_count <= w_count - w_last + w;
                    w_last <= w;
                end else begin
                    // Continue current window - just add new value
                    w_count <= w_count + w;
                end
                
                // Register ones_count for better timing
                ones_count <= w_count;
                
                // Output is registered for better timing
                z <= eval_now ? (ones_count == 2'd2) : 1'b0;
            end else begin
                // Reset counters in state A
                pos_cnt <= 2'b0;
                w_count <= 2'b0;
                w_last <= 1'b0;
                z <= 1'b0;
                eval_now <= 1'b0;
                ones_count <= 2'b0;
            end
        end
    end

endmodule