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
    reg [13:0] timer;  // Enough for (15+1)*1000 = 16000 cycles
    reg [3:0] delay_val;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            timer <= 14'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        delay_val <= 4'b0;
                    end
                end

                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    if (&delay_val[2:0]) begin  // After 4 bits captured
                        timer <= (delay_val + 1) * 1000;
                        state <= COUNT;
                        counting <= 1'b1;
                    end
                end

                COUNT: begin
                    if (timer > 0) begin
                        timer <= timer - 1;
                        count <= (timer - 1) / 1000;  // Update count output
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        done <= 1'b0;
                        state <= IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule