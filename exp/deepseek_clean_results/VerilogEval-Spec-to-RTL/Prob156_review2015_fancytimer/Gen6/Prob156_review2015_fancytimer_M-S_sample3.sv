module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    parameter IDLE = 0;
    parameter COUNTING = 1;
    parameter DONE = 2;

    reg [1:0] state;
    reg [7:0] shift_reg;       // Combines pattern and delay capture
    reg [3:0] delay;           // Captured delay value
    reg [13:0] counter;        // 14-bit counter for up to 16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[6:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    // Detect pattern 1101 in first 4 bits and capture next 4 as delay
                    if (shift_reg[7:4] == 4'b1101 && shift_reg[3] !== 1'bx) begin
                        state <= COUNTING;
                        delay <= shift_reg[3:0];
                        counter <= (shift_reg[3:0] + 1) * 1000 - 1;
                        counting <= 1;
                    end
                end

                COUNTING: begin
                    if (counter == 0) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        counter <= counter - 1;
                    end
                    // Calculate current remaining time (counts down every 1000 cycles)
                    count <= (counter / 1000);
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        shift_reg <= 8'b0;
                    end
                end
            endcase
        end
    end

endmodule