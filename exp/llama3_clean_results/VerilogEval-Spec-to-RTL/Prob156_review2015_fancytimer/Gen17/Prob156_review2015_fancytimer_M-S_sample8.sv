module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [1:0] state;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] seq;

// State machine
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
        seq <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq <= {data, seq[2:0]};
                if (seq == 4'b1101) begin
                    state <= 1;
                    delay <= 0;
                end
            end
            1: begin // SHIFT_DELAY
                delay <= {data, delay[2:0]};
                if (delay[0] == 1'b1) begin
                    state <= 2;
                    counter <= (delay + 1) * 1000 - 1;
                end
            end
            2: begin // COUNT
                if (counter > 0) begin
                    counter <= counter - 1;
                    counting <= 1;
                    count <= (counter / 1000);
                end else begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                end else begin
                    done <= 1;
                end
            end
        endcase
    end
end

endmodule