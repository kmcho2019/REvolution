module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

    reg [3:0] delay;
    reg [3:0] remaining_time;
    reg [3:0] current_count;
    reg [2:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: WAIT_ACK
    reg [3:0] shift_reg;
    reg [3:0] bit_count;
    reg counting_reg;
    reg done_reg;
    reg [9:0] clock_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            delay <= 4'b0;
            remaining_time <= 4'b0;
            current_count <= 4'b0;
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
            clock_count <= 10'b0;
            shift_reg <= 4'b0;
            bit_count <= 4'b0;
        end else begin
            case (state)
                0: begin // IDLE
                    if (data == 1'b1) begin
                        shift_reg[3] <= 1'b1;
                        state <= 1;
                    end else if (data == 1'b0) begin
                        shift_reg[3] <= 1'b0;
                        state <= 1;
                    end
                end
                1: begin // SHIFT
                    if (bit_count == 4'b0) begin
                        shift_reg <= {shift_reg[2:0], data};
                    end else if (bit_count == 4'b1) begin
                        shift_reg <= {shift_reg[2:0], data};
                    end else if (bit_count == 4'b2) begin
                        shift_reg <= {shift_reg[2:0], data};
                    end else if (bit_count == 4'b3) begin
                        shift_reg <= {shift_reg[2:0], data};
                    end
                    bit_count <= bit_count + 1;
                    if (bit_count == 4'b4) begin
                        delay <= shift_reg;
                        remaining_time <= delay + 1;
                        state <= 2;
                        current_count <= delay;
                        counting_reg <= 1'b1;
                    end
                end
                2: begin // COUNT
                    if (clock_count == 10'b1000) begin
                        clock_count <= 10'b0;
                        if (current_count != 4'b0) begin
                            current_count <= current_count - 1;
                        end
                    end
                    clock_count <= clock_count + 1;
                    if (current_count == 4'b0) begin
                        counting_reg <= 1'b0;
                        state <= 3;
                        done_reg <= 1'b1;
                    end
                end
                3: begin // WAIT_ACK
                    if (ack == 1'b1) begin
                        state <= 0;
                        done_reg <= 1'b0;
                    end
                end
            endcase
        end
    end

    assign count = current_count;
    assign counting = counting_reg;
    assign done = done_reg;

endmodule