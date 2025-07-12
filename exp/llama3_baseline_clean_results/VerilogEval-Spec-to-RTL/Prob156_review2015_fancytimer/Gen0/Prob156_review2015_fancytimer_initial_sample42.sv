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
reg [9:0] counter;
reg [3:0] shift_reg;
reg start_found;

enum logic [2:0] {IDLE, SEARCH, SHIFT, COUNT, WAIT_ACK} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_found <= 1'b0;
        delay <= 4'b0;
        counter <= 10'b0;
        count <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                    if (shift_reg == 4'b1101) begin
                        start_found <= 1'b1;
                        state <= SEARCH;
                    end
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SEARCH: begin
                if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == 4'b0000) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == 4'b0000) begin
                    delay <= {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
                    state <= COUNT;
                    counter <= 10'b0;
                    counting <= 1'b1;
                    done <= 1'b0;
                end
            end
            COUNT: begin
                counter <= counter + 1'b1;
                if (counter == (delay + 1'b1) * 1000 - 1) begin
                    state <= WAIT_ACK;
                    done <= 1'b1;
                    counting <= 1'b0;
                end
                count <= delay - (counter / 1000);
            end
            WAIT_ACK: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    start_found <= 1'b0;
                    delay <= 4'b0;
                    counter <= 10'b0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule