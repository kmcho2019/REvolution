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
reg [3:0] seq_reg;
reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        seq_reg <= 0;
        delay <= 0;
        counter <= 0;
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
            1: begin // SHIFT
                delay <= {data, delay[3:1]};
                if (delay[0] == 1'b1) begin
                    state <= 2;
                    counter <= (delay + 1) * 1000 - 1;
                    count <= delay;
                    counting <= 1;
                end else begin
                    delay <= {data, delay[3:1]};
                end
            end
            2: begin // COUNT
                counter <= counter - 1;
                if (counter % 1000 == 0) begin
                    count <= count - 1;
                end
                if (counter == 0) begin
                    state <= 3;
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule