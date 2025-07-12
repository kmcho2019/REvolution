module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam IDLE     = 4'b0001;
    localparam CAPTURE  = 4'b0010;
    localparam COUNTING = 4'b0100;
    localparam DONE     = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;    // For 1101 detection
    reg [3:0] delay_reg;      // For delay value storage
    reg [3:0] main_counter;   // Counts down delay value
    reg [9:0] sub_counter;    // Counts 0-999 cycles
    reg [1:0] bit_counter;    // Tracks captured bits

    // Continuous assignments for outputs
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? main_counter : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            main_counter <= 4'b0;
            sub_counter <= 10'b0;
            bit_counter <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    // Check for pattern after full shift
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 2'b0;
                    end
                end
                
                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    delay_reg <= {delay_reg[2:0], data};
                    
                    if (bit_counter == 2'b11) begin
                        // Initialize counters
                        main_counter <= delay_reg;
                        sub_counter <= 10'b0;
                        state <= COUNTING;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNTING: begin
                    if (sub_counter == 10'd999) begin
                        sub_counter <= 10'b0;
                        if (main_counter == 4'b0) begin
                            state <= DONE;
                        end else begin
                            main_counter <= main_counter - 1;
                        end
                    end else begin
                        sub_counter <= sub_counter + 1;
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