module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State definitions
    localparam IDLE       = 3'b000;
    localparam DETECT     = 3'b001;
    localparam CAPTURE    = 3'b010;
    localparam COUNTING   = 3'b011;
    localparam DONE       = 3'b100;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [3:0] bits_captured;
    reg [9:0] chunk_counter;  // Counts 0-999
    reg [3:0] remaining_chunks;
    
    // Continuous assignments for outputs
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? remaining_chunks : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bits_captured <= 4'b0;
            chunk_counter <= 10'b0;
            remaining_chunks <= 4'b0;
        end else begin
            // Shift in new data for pattern detection
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                IDLE: begin
                    state <= DETECT;
                end

                DETECT: begin
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bits_captured <= 4'b0;
                    end
                end

                CAPTURE: begin
                    if (bits_captured == 4'd3) begin
                        delay <= {delay[2:0], data};
                        remaining_chunks <= {delay[2:0], data};
                        chunk_counter <= 10'b0;
                        state <= COUNTING;
                    end else begin
                        delay <= {delay[2:0], data};
                        bits_captured <= bits_captured + 1;
                    end
                end

                COUNTING: begin
                    if (chunk_counter == 10'd999) begin
                        chunk_counter <= 10'b0;
                        if (remaining_chunks == 4'b0) begin
                            state <= DONE;
                        end else begin
                            remaining_chunks <= remaining_chunks - 1;
                        end
                    end else begin
                        chunk_counter <= chunk_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule