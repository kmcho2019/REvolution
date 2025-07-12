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
reg [3:0] remaining_time;
reg [3:0] current_count;
reg [3:0] sequence_detector;
reg [1:0] state;
reg [11:0] clock_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        sequence_detector <= 4'b0000;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        current_count <= 4'b0000;
        clock_counter <= 12'b0000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (sequence_detector == 4'b1101) begin
                    state <= 2'b01;
                end else begin
                    sequence_detector <= {sequence_detector[2:0], data};
                end
            end
            2'b01: begin // SHIFT
                delay <= {delay[2:0], data};
                sequence_detector <= 4'b0000;
                if (delay[3] == 1'b1) begin
                    state <= 2'b10;
                    remaining_time <= delay + 1'b1;
                    current_count <= delay + 1'b1;
                    clock_counter <= 12'b0000;
                    counting <= 1'b1;
                end
            end
            2'b10: begin // COUNT
                if (clock_counter == 12'b1111101000) begin
                    clock_counter <= 12'b0000;
                    if (current_count > 4'b0000) begin
                        current_count <= current_count - 1'b1;
                    end else begin
                        state <= 2'b11;
                    end
                end else begin
                    clock_counter <= clock_counter + 1'b1;
                end
                count <= current_count;
            end
            2'b11: begin // DONE
                done <= 1'b1;
                counting <= 1'b0;
                if (ack == 1'b1) begin
                    state <= 2'b00;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule