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
    reg [15:0] total_cycles;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 16'b0;
            chunk_counter <= 10'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    done <= 1'b0;
                    counting <= 1'b0;
                    
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        pattern_reg <= 4'b0; // Clear pattern after detection
                        bit_counter <= 3'd0;
                    end
                end

                CAPTURE: begin
                    if (bit_counter < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                    
                    if (bit_counter == 3) begin  // After capturing 4 bits
                        state <= COUNTING;
                        counting <= 1'b1;
                        total_cycles <= (delay_val + 1) * 16'd1000;
                        cycle_counter <= 16'd0;
                        chunk_counter <= 10'd0;
                        count <= delay_val;
                    end
                end

                COUNTING: begin
                    if (cycle_counter < total_cycles - 1) begin
                        cycle_counter <= cycle_counter + 1;
                        
                        if (chunk_counter == 10'd999) begin
                            chunk_counter <= 10'd0;
                            if (count > 0) count <= count - 1;
                        end else begin
                            chunk_counter <= chunk_counter + 1;
                        end
                    end else begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        count <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule