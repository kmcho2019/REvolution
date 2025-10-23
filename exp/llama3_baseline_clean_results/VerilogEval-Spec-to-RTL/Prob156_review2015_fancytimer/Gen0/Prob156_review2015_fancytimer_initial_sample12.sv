module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: READ_DELAY, 2: COUNTING, 3: DONE
reg [3:0] delay; // 4-bit delay value
reg [3:0] counter; // counter for counting down delay value
reg [3:0] remaining_time; // current remaining time
reg [3:0] shift_register; // shift register for reading delay value
reg [2:0] bit_counter; // counter for reading delay value bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        shift_register <= 0;
        bit_counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (shift_register == 4'b1101) begin
                    state <= 1; // READ_DELAY
                    shift_register <= 0;
                    bit_counter <= 0;
                end
                else if (data) begin
                    shift_register[3:1] <= shift_register[2:0];
                    shift_register[0] <= data;
                end
            end
            1: begin // READ_DELAY
                if (bit_counter == 4) begin
                    state <= 2; // COUNTING
                    delay <= shift_register;
                    counter <= delay + 1;
                    remaining_time <= delay;
                end
                else begin
                    shift_register[3:1] <= shift_register[2:0];
                    shift_register[0] <= data;
                    bit_counter <= bit_counter + 1;
                end
            end
            2: begin // COUNTING
                if (counter == 0) begin
                    state <= 3; // DONE
                end
                else if (counter % 1000 == 0) begin
                    remaining_time <= remaining_time - 1;
                end
                counter <= counter - 1;
                counting <= 1;
                count <= remaining_time;
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                end
                done <= 1;
            end
        endcase
    end
end

endmodule