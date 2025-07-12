module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // States: IDLE = 1'b0, IN_MSG = 1'b1 (one-hot)
    reg state;
    reg [1:0] count;
    reg done_reg;

    wire start_byte = in[3];
    wire cnt_enable;

    assign cnt_enable = (state == 1'b1);

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;      // IDLE
            count <= 2'd0;
            done <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            done <= done_reg;   // Output done pulse from previous cycle
            done_reg <= 1'b0;   // Default no done pulse

            case (state)
                1'b0: begin // IDLE
                    count <= 2'd0;
                    if (start_byte) begin
                        state <= 1'b1;   // Move to IN_MSG
                        count <= 2'd1;   // First byte received
                    end
                end

                1'b1: begin // IN_MSG
                    if (cnt_enable) begin
                        if (count == 2'd2) begin
                            done_reg <= 1'b1; // done after third byte
                            count <= 2'd0;
                            state <= 1'b0;   // return to IDLE
                        end else begin
                            count <= count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end

endmodule