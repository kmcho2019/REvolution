module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;
reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        remaining <= 0;
        counter <= 0;
        shift_reg <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1 && shift_reg == 4'b110) begin
                    shift_reg <= shift_reg << 1 | data;
                    if (shift_reg == 4'b1101) begin
                        state <= 1;
                    end
                end else if (data == 1) begin
                    shift_reg <= shift_reg << 1 | data;
                end else begin
                    shift_reg <= 0;
                end
            end
            1: begin // SHIFT
                shift_reg <= shift_reg << 1 | data;
                if (shift_reg[0] == 1'b1) begin
                    delay <= shift_reg[3:0];
                    state <= 2;
                    counter <= 0;
                    remaining <= delay;
                end
            end
            2: begin // COUNT
                counting <= 1;
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= 3;
                    end
                end
                count <= remaining;
            end
            3: begin // DONE
                done <= 1;
                counting <= 0;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule