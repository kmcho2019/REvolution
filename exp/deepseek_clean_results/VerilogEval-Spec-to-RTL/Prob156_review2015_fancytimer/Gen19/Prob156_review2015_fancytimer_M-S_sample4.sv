module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;  // Stores both pattern (bits 7:4) and delay (bits 3:0)
    reg [15:0] cycle_counter;
    reg [3:0] delay_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            cycle_counter <= 16'b0;
            delay_count <= 4'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    shift_reg <= {shift_reg[6:0], data};
                    
                    // Check for pattern 1101 in bits 7:4 and transition if found
                    if (shift_reg[7:4] == 4'b1101) begin
                        state <= COUNTING;
                        delay_count <= shift_reg[3:0];
                        count <= shift_reg[3:0];
                        cycle_counter <= 16'd0;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    
                    // Every 1000 cycles, decrement the count
                    if (cycle_counter % 1000 == 999) begin
                        if (count == 0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                        else begin
                            count <= count - 1;
                        end
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        shift_reg <= 8'b0;
                    end
                end
            endcase
        end
    end

endmodule