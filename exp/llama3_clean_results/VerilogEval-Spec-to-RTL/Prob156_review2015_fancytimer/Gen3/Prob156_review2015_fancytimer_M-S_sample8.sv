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
reg [2:0] state;
reg [3:0] shift_count;
reg [3:0] seq_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        seq_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    state <= 1;
                    seq_reg <= 0;
                end
            end
            1: begin // SHIFT
                if (shift_count < 4) begin
                    delay[3 - shift_count] <= data;
                    shift_count <= shift_count + 1;
                end else begin
                    state <= 2;
                    counter <= 0;
                    counting <= 1'b1;
                    count <= delay;
                    shift_count <= 0;
                end
            end
            2: begin // COUNT
                if (counter < ((delay + 1) * 1000) - 1) begin
                    counter <= counter + 1;
                    if (counter % 1000 == 0) begin
                        count <= count - 1;
                    end
                end else begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1'b1;
                if (ack == 1'b1) begin
                    state <= 0;
                    done <= 0;
                    delay <= 0;
                    counter <= 0;
                    count <= 0;
                end
            end
        endcase
    end
end

endmodule