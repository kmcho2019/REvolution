module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;  // 4-bit delay register
reg [11:0] counter;  // 12-bit counter to count down from (delay+1) * 1000
reg [3:0] countdown;  // register to display the remaining time
reg [3:0] shift_reg;  // register to store the input sequence
reg start_sequence_found;  // flag to indicate the start sequence has been found
reg [1:0] state;  // state machine state: 0 - IDLE, 1 - SHIFT, 2 - COUNT, 3 - DONE

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        start_sequence_found <= 0;
        delay <= 0;
        counter <= 0;
        countdown <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
        shift_reg <= 0;
    end
    else begin
        case (state)
            0: begin  // IDLE
                if (~start_sequence_found) begin
                    if (data == 1) begin
                        shift_reg <= {shift_reg[2:0], 1};
                    end
                    else begin
                        shift_reg <= {shift_reg[2:0], 0};
                    end
                    if (shift_reg == 4'b1101) begin
                        start_sequence_found <= 1;
                    end
                end
                else begin
                    state <= 1;
                end
            end
            1: begin  // SHIFT
                if (data == 1) begin
                    delay <= {delay[2:0], 1};
                end
                else begin
                    delay <= {delay[2:0], 0};
                end
                if (shift_reg == 4'b0000) begin
                    state <= 2;
                    counter <= ((delay + 1) * 1000);
                    countdown <= delay;
                end
                shift_reg <= shift_reg + 1;
            end
            2: begin  // COUNT
                counting <= 1;
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        countdown <= countdown - 1;
                    end
                end
                else begin
                    state <= 3;
                    done <= 1;
                end
                count <= countdown;
            end
            3: begin  // DONE
                if (ack) begin
                    state <= 0;
                    start_sequence_found <= 0;
                    done <= 0;
                    counting <= 0;
                end
            end
        endcase
    end
end
endmodule