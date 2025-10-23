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
    localparam SEARCH      = 2'b00;
    localparam COUNT       = 2'b01;
    localparam COMPLETE    = 2'b10;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [9:0] prescaler;
    reg [3:0] chunk_counter;
    reg pattern_matched;

    // Parallel pattern detection (1101)
    always @(*) begin
        pattern_matched = (shift_reg == 4'b1101);
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            prescaler <= 0;
        end else begin
            case (state)
                SEARCH: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (pattern_matched) begin
                        state <= COUNT;
                        delay <= 4'b0;  // Prepare to capture delay
                        counting <= 1;
                        prescaler <= 0;
                        chunk_counter <= 4'b0;
                    end
                    done <= 0;
                end

                COUNT: begin
                    // Capture delay bits if we're still in first 4 cycles
                    if (chunk_counter < 4) begin
                        delay <= {delay[2:0], data};
                        chunk_counter <= chunk_counter + 1;
                    end
                    else begin
                        // Normal counting operation
                        prescaler <= prescaler + 1;
                        if (prescaler == 999) begin
                            prescaler <= 0;
                            count <= count - 1;
                            if (count == 0) begin
                                state <= COMPLETE;
                                counting <= 0;
                                done <= 1;
                            end
                        end
                    end

                    // Initialize counter after delay is captured
                    if (chunk_counter == 4) begin
                        count <= delay;
                    end
                end

                COMPLETE: begin
                    if (ack) begin
                        state <= SEARCH;
                        shift_reg <= 4'b0;
                        done <= 0;
                    end
                end
            endcase
        end
    end
endmodule