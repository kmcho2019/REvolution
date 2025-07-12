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
reg [19:0] counter;
reg [1:0] bit_counter;
reg [3:0] seq_reg;
reg state; // 0: IDLE, 1: SHIFT/COUNT, 2: DONE

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay <= 0;
        counter <= 0;
        bit_counter <= 0;
        counting <= 0;
        done <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT/COUNT
                if (bit_counter < 4) begin
                    delay <= {data, delay[3:1]};
                    bit_counter <= bit_counter + 1;
                end else if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        count <= count - 1;
                    end
                    counting <= 1;
                end else begin
                    state <= 2;
                    counting <= 0;
                    done <= 1;
                end
            end
            2: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

// Initialize counter
always @(posedge clk) begin
    if (bit_counter == 4 && counter == 0) begin
        counter <= (delay + 1) * 1000 - 1;
        count <= delay;
    end
end

endmodule