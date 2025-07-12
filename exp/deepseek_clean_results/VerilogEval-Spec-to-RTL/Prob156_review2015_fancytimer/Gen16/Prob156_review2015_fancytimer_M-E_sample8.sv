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
    localparam GOT_1       = 3'b001;
    localparam GOT_11      = 3'b010;
    localparam GOT_110     = 3'b011;
    localparam CAPTURE     = 3'b100;
    localparam COUNTING    = 3'b101;
    localparam WAIT_ACK    = 3'b110;

    reg [2:0] state;
    reg [3:0] delay;
    reg [1:0] bit_count;
    reg [9:0] cycle_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] chunk_counter;  // Counts delay chunks

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            delay <= 4'b0;
            bit_count <= 2'b0;
            cycle_counter <= 10'b0;
            chunk_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    if (data) state <= GOT_1;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                GOT_1: begin
                    if (data) state <= GOT_11;
                    else state <= SEARCH;
                end

                GOT_11: begin
                    if (~data) state <= GOT_110;
                    else state <= GOT_11;  // Stay if we get more 1's
                end

                GOT_110: begin
                    if (data) begin
                        state <= CAPTURE;
                        bit_count <= 2'b0;
                    end else begin
                        state <= SEARCH;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 2'b11) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        chunk_counter <= delay;
                        cycle_counter <= 10'b0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (chunk_counter == 4'b0) begin
                            state <= WAIT_ACK;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            chunk_counter <= chunk_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= chunk_counter;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 1'b0;
                    end
                end

                default: state <= SEARCH;
            endcase
        end
    end

endmodule