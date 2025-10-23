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
    localparam SEARCH      = 3'b000;
    localparam CAPTURE     = 3'b001;
    localparam COUNT_SETUP = 3'b010;
    localparam COUNTING    = 3'b011;
    localparam FINISHED    = 3'b100;
    localparam WAIT_ACK    = 3'b101;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] bit_counter;
    reg [9:0] chunk_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] delay_counter;  // Counts delay chunks

    // Pattern detection comparator
    wire pattern_match = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 4'b0;
            chunk_counter <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_counter <= 4'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;  // Don't-care when not counting
                end

                CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 4'd3) begin
                        state <= COUNT_SETUP;
                    end
                end

                COUNT_SETUP: begin
                    delay_counter <= delay_reg;
                    chunk_counter <= 10'd0;
                    state <= COUNTING;
                    counting <= 1'b1;
                    count <= delay_reg;  // Immediate update of count output
                end

                COUNTING: begin
                    if (chunk_counter == 10'd999) begin
                        chunk_counter <= 10'd0;
                        if (delay_counter == 4'b0) begin
                            state <= FINISHED;
                            counting <= 1'b0;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            count <= delay_counter - 1;  // Update count immediately
                        end
                    end else begin
                        chunk_counter <= chunk_counter + 1;
                    end
                end

                FINISHED: begin
                    done <= 1'b1;
                    state <= WAIT_ACK;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 1'b0;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule