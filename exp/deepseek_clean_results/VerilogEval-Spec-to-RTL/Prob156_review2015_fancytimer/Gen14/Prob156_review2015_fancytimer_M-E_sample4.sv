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
    localparam IDLE      = 3'b000;
    localparam PATTERN   = 3'b001;
    localparam VALIDATE  = 3'b010;
    localparam CAPTURE   = 3'b011;
    localparam COUNTING  = 3'b100;
    localparam DONE      = 3'b101;

    reg [2:0] state;
    reg [3:0] pattern_shift;  // For 1101 detection
    reg [3:0] delay_shift;    // For capturing delay bits
    reg [3:0] delay_reg;      // Stored delay value
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] chunk_counter;  // Counts delay+1 chunks
    reg [1:0] bit_count;      // Tracks captured bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay_shift <= 4'b0;
            delay_reg <= 4'b0;
            cycle_counter <= 10'b0;
            chunk_counter <= 4'b0;
            bit_count <= 2'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Reset all outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    
                    // Shift in new data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    if (pattern_shift == 4'b1101) begin
                        state <= VALIDATE;
                    end
                end

                VALIDATE: begin
                    // Confirm pattern detection and prepare for delay capture
                    state <= CAPTURE;
                    delay_shift <= 4'b0;
                    bit_count <= 2'b0;
                end

                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    delay_shift <= {delay_shift[2:0], data};
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 2'd3) begin
                        state <= COUNTING;
                        delay_reg <= delay_shift;
                        chunk_counter <= delay_shift + 1; // Initialize to delay+1
                        cycle_counter <= 10'b0;
                        counting <= 1'b1;
                        count <= delay_shift; // Initial count value
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        // Completed 1000 cycles
                        cycle_counter <= 10'b0;
                        chunk_counter <= chunk_counter - 1;
                        
                        if (chunk_counter == 4'd1) begin
                            // Final chunk completed
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            // Update count output for next chunk
                            count <= chunk_counter - 2;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_shift <= 4'b0;
                        done <= 1'b0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule