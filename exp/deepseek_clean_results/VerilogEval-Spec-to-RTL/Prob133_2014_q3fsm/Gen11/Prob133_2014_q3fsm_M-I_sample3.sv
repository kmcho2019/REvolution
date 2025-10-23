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
    reg [1:0] pos_cnt;
    reg [1:0] w_count;  // Stores count of 1's in current window
    reg w_prev1, w_prev2;  // Stores last two w values
    
    // Evaluation control
    reg eval_now;
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_count <= 2'b0;
            w_prev1 <= 1'b0;
            w_prev2 <= 1'b0;
            eval_now <= 1'b0;
            z <= 1'b0;
        end else begin
            // Default assignments
            eval_now <= 1'b0;
            z <= 1'b0;
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        pos_cnt <= 2'b01;  // Start counting from first cycle
                        w_count <= w ? 2'b01 : 2'b00;
                        w_prev1 <= w;
                    end
                end
                
                B: begin
                    if (pos_cnt == 2'b10) begin
                        // Window complete - evaluate next cycle
                        eval_now <= 1'b1;
                        pos_cnt <= 2'b00;
                    end else begin
                        pos_cnt <= pos_cnt + 1'b1;
                    end
                    
                    // Update rolling counter
                    w_count <= w_count + (w ? 1'b1 : 1'b0) - (w_prev2 ? 1'b1 : 1'b0);
                    w_prev2 <= w_prev1;
                    w_prev1 <= w;
                    
                    // Output evaluation (one cycle delayed from window completion)
                    if (eval_now) begin
                        z <= (w_count == 2'd2);
                    end
                end
            endcase
        end
    end

endmodule