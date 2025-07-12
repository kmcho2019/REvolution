module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    // State encoding
    localparam IDLE    = 1'b0;
    localparam COLLECT = 1'b1;

    reg state;
    reg [3:0] cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            cnt           <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default clear output valid

            case (state)
                IDLE: begin
                    if (din_valid) begin
                        // Start collecting bits
                        // Shift in first bit at LSB, MSB cleared
                        shift_reg <= {7'd0, din_serial};
                        cnt       <= 4'd0;
                        state     <= COLLECT;
                    end
                end

                COLLECT: begin
                    if (din_valid) begin
                        // Shift left by 1, input bit at LSB
                        shift_reg <= {shift_reg[6:0], din_serial};
                        if (cnt == 4'd7) begin
                            dout_parallel <= {shift_reg[6:0], din_serial};
                            dout_valid    <= 1'b1;
                            cnt           <= 4'd0;
                            state         <= IDLE;
                        end else begin
                            cnt <= cnt + 1'b1;
                        end
                    end
                end

                default: begin
                    // Defensive coding, should not happen
                    state         <= IDLE;
                    cnt           <= 4'd0;
                    shift_reg     <= 8'd0;
                    dout_parallel <= 8'd0;
                    dout_valid    <= 1'b0;
                end
            endcase
        end
    end

endmodule