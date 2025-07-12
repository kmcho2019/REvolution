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
    localparam IDLE    = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [13:0] counter;  // Enough for (15+1)*1000 = 16000 cycles
    reg [3:0] delay;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counter <= 0;
            delay <= 0;
            counting <= 0;
            done <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        shift_reg <= 4'b0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                CAPTURE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (&shift_reg[2:0]) begin  // After 4 shifts
                        delay <= shift_reg;
                        counter <= ({shift_reg, 10'b0} + 14'd1000);
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1;
                    if (counter == 0) begin
                        state <= DONE;
                    end else begin
                        counter <= counter - 1;
                    end
                    count <= (counter / 1000);  // Automatically floors
                end

                DONE: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule