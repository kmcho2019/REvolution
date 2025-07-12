module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // States
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_cnt <= 0;
            pattern <= 0;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            // Continuously shift in data
            pattern <= {pattern[2:0], data};

            case (state)
                IDLE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        shift_ena <= 1;
                        shift_cnt <= 0;
                        pattern <= 0;  // Clear pattern after detection
                    end
                end

                SHIFT: begin
                    shift_ena <= 1;
                    shift_cnt <= shift_cnt + 1;
                    
                    if (shift_cnt == 2'b11) begin
                        state <= COUNT;
                        counting <= 1;
                        shift_ena <= 0;
                    end
                end

                COUNT: begin
                    counting <= 1;
                    shift_ena <= 0;
                    
                    if (done_counting) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end
                end

                DONE: begin
                    done <= 1;
                    counting <= 0;
                    shift_ena <= 0;
                    
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule