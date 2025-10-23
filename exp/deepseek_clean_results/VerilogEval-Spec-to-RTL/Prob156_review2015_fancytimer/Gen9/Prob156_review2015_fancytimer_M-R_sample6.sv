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
    reg [3:0] pattern_reg;    // For 1101 detection
    reg [3:0] delay;          // Captured delay value
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] chunk_counter;  // Counts delay down to 0

    // Continuous assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? chunk_counter : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay <= 4'b0;
            cycle_counter <= 10'b0;
            chunk_counter <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        delay <= 4'b0;  // Prepare to capture delay
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    if (&pattern_reg[2:0]) begin  // After 4 shifts
                        state <= COUNTING;
                        chunk_counter <= delay;
                        cycle_counter <= 10'b0;
                    end
                    pattern_reg <= {pattern_reg[2:0], 1'b0};  // Mark progress
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