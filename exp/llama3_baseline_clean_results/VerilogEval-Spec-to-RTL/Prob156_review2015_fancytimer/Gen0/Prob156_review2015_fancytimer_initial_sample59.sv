module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining_delay;
reg [11:0] counter;
reg [3:0] shift_reg;
reg shift_reg_full;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
        counting <= 0;
        shift_reg_full <= 0;
        counter <= 0;
        remaining_delay <= 0;
        count <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (shift_reg_full) begin
                    if (shift_reg == 4'b1101) begin
                        state <= 1;
                        shift_reg_full <= 0;
                    end
                    else begin
                        shift_reg_full <= 0;
                    end
                end
                else begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg[3] == 1'b1) begin
                        shift_reg_full <= 1;
                    end
                end
            end
            1: begin // SHIFT
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3] == 1'b1) begin
                    state <= 2;
                    delay <= shift_reg[3:0];
                    remaining_delay <= delay;
                    counting <= 1;
                end
            end
            2: begin // COUNT
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining_delay <= remaining_delay - 1;
                    count <= remaining_delay;
                end
                if (remaining_delay == 0) begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule