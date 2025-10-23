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
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] delay_shift;
    reg [9:0] cycle_counter;
    reg [3:0] chunk_counter;
    reg [1:0] capture_count;

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? chunk_counter : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            delay_shift <= 4'b0;
            cycle_counter <= 10'b0;
            chunk_counter <= 4'b0;
            capture_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data
                    pattern_reg <= {pattern_reg[2:0], data};
                    // Check for pattern match only after full shift
                    if (pattern_reg[2:0] == 3'b110 && data == 1'b1) begin
                        state <= CAPTURE;
                        delay_shift <= 4'b0;
                        capture_count <= 2'b0;
                    end
                end

                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    delay_shift <= {delay_shift[2:0], data};
                    capture_count <= capture_count + 1;
                    if (capture_count == 2'd3) begin
                        state <= COUNTING;
                        delay_reg <= delay_shift;
                        chunk_counter <= delay_shift; // Initialize with delay value
                        cycle_counter <= 10'b0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (chunk_counter == 4'b0) begin
                            state <= DONE;
                        end else begin
                            chunk_counter <= chunk_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule