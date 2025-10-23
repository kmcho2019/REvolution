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

    // Combined shift register and counter
    reg [2:0] w_history;
    reg [1:0] pos_cnt;
    reg eval_now;
    reg [1:0] ones_count;

    // Clock gating for w_history
    wire update_history = (state == B) && !reset;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_history <= 3'b0;
            eval_now <= 1'b0;
            z <= 1'b0;
            ones_count <= 2'b0;
        end else begin
            state <= next_state;
            eval_now <= 1'b0;
            z <= 1'b0;
            
            if (state == B) begin
                // Update position counter (modulo 3)
                pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);
                
                // Clock-gated shift register update
                if (update_history) begin
                    w_history <= {w_history[1:0], w};
                end
                
                // Pipeline stage 1: Calculate ones_count when window is full
                if (pos_cnt == 2'b10) begin
                    ones_count <= w_history[0] + w_history[1] + w;
                end
                
                // Pipeline stage 2: Evaluate condition one cycle after window
                if (pos_cnt == 2'b00) begin
                    eval_now <= 1'b1;
                    z <= (ones_count == 2'd2);
                end
            end else begin
                // Reset counters in state A
                pos_cnt <= 2'b0;
                w_history <= 3'b0;
                ones_count <= 2'b0;
            end
        end
    end

endmodule