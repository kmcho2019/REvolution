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

    // Window tracking and data capture
    reg [1:0] pos_cnt;
    reg [2:0] w_history;
    reg z_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            pos_cnt <= 2'b0;
            w_history <= 3'b0;
            z_reg <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        pos_cnt <= 2'b0;
                        w_history <= 3'b0;
                    end
                    z_reg <= 1'b0;
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};
                    
                    // Update position counter
                    pos_cnt <= (pos_cnt == 2'b10) ? 2'b00 : (pos_cnt + 1'b1);
                    
                    // Evaluate when window completes (pos_cnt was 2)
                    if (pos_cnt == 2'b10) begin
                        z_reg <= ($countones(w_history) == 2);
                    end else begin
                        z_reg <= 1'b0;
                    end
                end
            endcase
        end
    end

    assign z = z_reg;

endmodule