module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [11:0] cycle_count;
reg [3:0] shift_reg;
reg start_detected;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'bxxxx;
        counting <= 1'b0;
        done <= 1'b0;
        delay <= 4'b0000;
        remaining <= 4'b0000;
        cycle_count <= 12'b0000;
        shift_reg <= 4'b0000;
        start_detected <= 1'b0;
    end else begin
        case ({start_detected, counting, done})
            3'b001: begin // IDLE and not counting and not done
                if (data == 1'b1) begin // first bit of start sequence
                    shift_reg <= {1'b1, shift_reg[2:0]};
                end else begin
                    shift_reg <= {1'b0, shift_reg[2:0]};
                end
                if (shift_reg == 4'b1101) begin
                    start_detected <= 1'b1;
                end else begin
                    start_detected <= 1'b0;
                end
            end
            3'b011: begin // DELAY_SHIFT
                if (data == 1'b1) begin // shifting in delay
                    delay <= {data, delay[2:0]};
                end else begin
                    delay <= {data, delay[2:0]};
                end
                // load the remaining time after 4 bits are shifted
                if (delay[0] == 1'b1) begin
                    remaining <= delay;
                    counting <= 1'b1;
                end
            end
            3'b010: begin // COUNTING
                if (cycle_count == 12'b1111101000) begin // 1000 cycles
                    cycle_count <= 12'b0000;
                    if (remaining > 4'b0000) begin
                        remaining <= remaining - 1'b1;
                        count <= remaining;
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                    count <= remaining;
                end
            end
            3'b000: begin // DONE
                if (ack == 1'b1) begin
                    done <= 1'b0;
                    start_detected <= 1'b0;
                    counting <= 1'b0;
                end
            end
        endcase
    end
end

endmodule