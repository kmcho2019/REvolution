module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    // States for FSM
    localparam IDLE  = 1'b0;
    localparam SHIFT = 1'b1;

    reg state;
    reg [2:0] bit_cnt;          // 3 bits sufficient to count 0 to 7
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            state         <= IDLE;
            bit_cnt       <= 3'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default: deassert dout_valid

            case(state)
                IDLE: begin
                    if (din_valid) begin
                        // Shift new bit into MSB on first valid bit
                        shift_reg <= {din_serial, 7'b0};
                        bit_cnt  <= 3'd1;
                        state    <= SHIFT;
                    end
                end

                SHIFT: begin
                    if (din_valid) begin
                        // Shift right by one, insert new bit at MSB
                        shift_reg <= {din_serial, shift_reg[7:1]};
                        if (bit_cnt == 3'd7) begin
                            dout_parallel <= {din_serial, shift_reg[7:1]}; // full byte assembled
                            dout_valid    <= 1'b1;                         // output valid for one cycle
                            bit_cnt      <= 3'd0;
                            state        <= IDLE;                          // back to IDLE for next input sequence
                        end else begin
                            bit_cnt <= bit_cnt + 1'b1;
                        end
                    end
                    // else no valid input, hold current data and count
                end
            endcase
        end
    end

endmodule