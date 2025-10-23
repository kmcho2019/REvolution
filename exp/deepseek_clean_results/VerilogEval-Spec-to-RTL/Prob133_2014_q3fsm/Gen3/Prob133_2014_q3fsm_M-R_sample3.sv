module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // FSM states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] pos_cnt;
    reg window_done;
    
    // Data capture
    reg [2:0] w_history;
    
    // Evaluation
    reg eval_now;
    reg z_reg;

    // State machine and window tracking
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            window_done <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        pos_cnt <= 2'b0;
                        window_done <= 1'b0;
                    end
                end
                B: begin
                    // Update position counter
                    pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);
                    
                    // Window completes when counter wraps
                    window_done <= (pos_cnt == 2'b10);
                end
            endcase
        end
    end

    // Data capture shift register
    always @(posedge clk) begin
        if (reset) begin
            w_history <= 3'b0;
        end else if (state == B) begin
            // Shift in new w value at LSB
            w_history <= {w_history[1:0], w};
        end
    end

    // Evaluation timing
    always @(posedge clk) begin
        if (reset) begin
            eval_now <= 1'b0;
        end else begin
            // Evaluate one cycle after window completes
            eval_now <= window_done;
        end
    end

    // Pattern matching (combinational)
    wire two_ones = (w_history == 3'b011) || 
                   (w_history == 3'b101) || 
                   (w_history == 3'b110);

    // Output generation
    always @(posedge clk) begin
        if (reset) begin
            z_reg <= 1'b0;
        end else if (eval_now) begin
            z_reg <= two_ones;
        end else begin
            z_reg <= 1'b0;
        end
    end

    assign z = z_reg;

endmodule