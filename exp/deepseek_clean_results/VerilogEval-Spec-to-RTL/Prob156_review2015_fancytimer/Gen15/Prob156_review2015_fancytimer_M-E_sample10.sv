module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam SEARCH   = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam WAIT_ACK = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;       // Shift register for 1101 pattern
    reg [3:0] delay;         // Captured delay value
    reg [2:0] bit_count;     // Counts 4 delay bits
    reg [15:0] main_counter; // Handles up to 16*1000=16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern <= 4'b0;
            delay <= 4'b0;
            bit_count <= 3'b0;
            main_counter <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    // Shift in new data for pattern detection
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        bit_count <= 3'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    delay <= {delay[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd3) begin
                        state <= COUNTING;
                        main_counter <= (delay + 1) * 1000 - 1;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    if (main_counter == 0) begin
                        state <= WAIT_ACK;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        main_counter <= main_counter - 1;
                    end
                    // count = floor(main_counter / 1000)
                    count <= main_counter / 1000;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 1'b0;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule