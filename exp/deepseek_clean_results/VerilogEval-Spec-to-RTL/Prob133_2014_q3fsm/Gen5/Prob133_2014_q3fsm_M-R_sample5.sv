module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Next state logic (combinational)
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Window tracking
    reg [1:0] pos_cnt;
    reg [2:0] w_history;
    wire window_done = (pos_cnt == 2'b10);  // Indicates when to evaluate next cycle

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_history <= 3'b0;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update position counter (modulo 3)
                pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);
                
                // Shift in new w value
                w_history <= {w_history[1:0], w};
            end else begin
                // Reset counters in state A
                pos_cnt <= 2'b0;
                w_history <= 3'b0;
            end
        end
    end

    // Output logic (combinational)
    wire eval_now = (state == B) && (pos_cnt == 2'b00);  // Evaluate one cycle after window_done
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = eval_now ? (ones_count == 2'd2) : 1'b0;

endmodule