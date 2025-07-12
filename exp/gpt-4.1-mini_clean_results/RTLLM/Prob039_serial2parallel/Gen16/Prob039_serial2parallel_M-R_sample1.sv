module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    localparam IDLE    = 1'b0,
               COLLECT = 1'b1;

    reg state;
    reg [7:0] shift_reg;
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            shift_reg     <= 8'b0;
            cnt           <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default to 0 each cycle

            case (state)
                IDLE: begin
                    if (din_valid) begin
                        // Capture first bit at MSB position
                        shift_reg <= {din_serial, 7'b0};
                        cnt <= 4'd0;
                        state <= COLLECT;
                    end
                end
                COLLECT: begin
                    if (din_valid) begin
                        // Shift right by one, insert new bit at MSB
                        shift_reg <= {din_serial, shift_reg[7:1]};
                        if (cnt == 4'd7) begin
                            dout_parallel <= {din_serial, shift_reg[7:1]};
                            dout_valid <= 1'b1;
                            state <= IDLE;  // ready for next frame
                        end else begin
                            cnt <= cnt + 1'b1;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule