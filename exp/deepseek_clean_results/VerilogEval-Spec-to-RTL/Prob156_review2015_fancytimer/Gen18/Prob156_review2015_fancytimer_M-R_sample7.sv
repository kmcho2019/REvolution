module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] bit_counter;
    reg [15:0] cycle_counter;
    reg [9:0] chunk_counter;

    // Continuous outputs
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 3'd3) ? COUNTING : CAPTURE;
            COUNTING: next_state = (cycle_counter == 0) ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 16'b0;
            chunk_counter <= 10'd999; // Start at 999 for simpler comparison
            count <= 4'b0;
        end else begin
            state <= next_state;

            // Pattern detection
            if (state == IDLE)
                pattern_reg <= {pattern_reg[2:0], data};
            else
                pattern_reg <= 4'b0;

            // Delay value capture
            if (state == CAPTURE) begin
                if (bit_counter < 4) begin
                    delay_val <= {delay_val[2:0], data};
                    bit_counter <= bit_counter + 1;
                end
                
                if (bit_counter == 3) begin
                    cycle_counter <= (delay_val + 1) * 16'd1000 - 1;
                    count <= delay_val;
                end
            end

            // Counting logic
            if (state == COUNTING) begin
                if (cycle_counter > 0) begin
                    cycle_counter <= cycle_counter - 1;
                    
                    if (chunk_counter == 0) begin
                        chunk_counter <= 10'd999;
                        count <= count - 1;
                    end else begin
                        chunk_counter <= chunk_counter - 1;
                    end
                end
            end

            // Reset counters when leaving COUNTING state
            if (state == DONE && next_state == IDLE) begin
                chunk_counter <= 10'd999;
                count <= 4'b0;
            end
        end
    end

endmodule