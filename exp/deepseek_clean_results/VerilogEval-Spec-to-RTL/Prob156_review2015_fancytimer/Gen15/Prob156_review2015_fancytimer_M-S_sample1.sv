module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;    // For 1101 detection
    reg [3:0] delay_shift;    // Stores delay value
    reg [1:0] bit_counter;    // Counts 4 captured bits
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] chunk_counter;  // Counts delay down to 0
    reg done_reg;

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = done_reg;
    assign count = (state == COUNTING) ? chunk_counter : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_shift <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 10'b0;
            chunk_counter <= 4'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (done_reg) begin
                        if (ack) begin
                            done_reg <= 1'b0;
                            pattern_reg <= 4'b0;
                        end
                    end else begin
                        pattern_reg <= {pattern_reg[2:0], data};
                        if (pattern_reg == 4'b1101) begin
                            state <= CAPTURE;
                            bit_counter <= 2'b0;
                        end
                    end
                end

                CAPTURE: begin
                    delay_shift <= {delay_shift[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2'b11) begin
                        state <= COUNTING;
                        chunk_counter <= delay_shift;
                        cycle_counter <= 10'b0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (chunk_counter == 4'd0) begin
                            state <= IDLE;
                            done_reg <= 1'b1;
                        end else begin
                            chunk_counter <= chunk_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
            endcase
        end
    end

endmodule