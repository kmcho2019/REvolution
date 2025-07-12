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

    // Window tracking
    reg [1:0] pos_cnt;       // Position in current window (0-2)
    reg oldest_w;            // Stores the oldest w in current window
    reg [1:0] ones_count;    // Running count of 1s in current window
    wire window_complete = (pos_cnt == 2'b10);  // Window completes next cycle

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            oldest_w <= 1'b0;
            ones_count <= 2'b0;
        end else begin
            case (state)
                A: begin
                    if (s) state <= B;
                    pos_cnt <= 2'b0;
                    oldest_w <= 1'b0;
                    ones_count <= 2'b0;
                end
                B: begin
                    // Update position counter (modulo 3)
                    pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);
                    
                    // Update oldest_w when window wraps
                    if (pos_cnt == 2'b10) oldest_w <= w;
                    
                    // Update running count
                    if (pos_cnt == 2'b00) begin
                        // New window starting - reset count with new w
                        ones_count <= w;
                    end else begin
                        // Update count: subtract oldest if leaving window, add new w
                        ones_count <= ones_count - oldest_w + w;
                    end
                end
            endcase
        end
    end

    // Output logic (registered)
    reg z_reg;
    always @(posedge clk) begin
        if (reset) begin
            z_reg <= 1'b0;
        end else begin
            z_reg <= (state == B) && window_complete && (ones_count == 2'd2);
        end
    end

    assign z = z_reg;

endmodule