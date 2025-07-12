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
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [9:0] sub_count;  // Counts 0-999
    reg [3:0] block_count; // Counts delay down to 0

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        delay <= 4'b0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    if (&delay[3:1]) begin  // After 4 shifts (delay[3] set)
                        state <= COUNT;
                        block_count <= delay;
                        sub_count <= 0;
                        counting <= 1;
                    end
                end

                COUNT: begin
                    if (sub_count == 999) begin
                        sub_count <= 0;
                        block_count <= block_count - 1;
                        count <= block_count - 1;
                        if (block_count == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end else begin
                        sub_count <= sub_count + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule