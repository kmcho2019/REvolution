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

    reg [1:0] state;
    reg [3:0] shift_reg;      // Dual-purpose: pattern detection and delay capture
    reg [15:0] main_counter;  // Handles up to 16*1000 = 16000 cycles
    reg [1:0] bit_counter;    // Tracks captured bits (0-3)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            main_counter <= 0;
            bit_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    count <= 4'b0;
                    
                    // Detect pattern 1101
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 0;
                    end
                end
                
                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    shift_reg <= {shift_reg[2:0], data};
                    
                    if (bit_counter == 3) begin
                        // Initialize counter: (delay+1)*1000 cycles
                        main_counter <= (shift_reg + 1) * 1000 - 1;
                        counting <= 1;
                        state <= COUNTING;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNTING: begin
                    if (main_counter == 0) begin
                        // Counting complete
                        counting <= 0;
                        done <= 1;
                        state <= DONE;
                    end else begin
                        main_counter <= main_counter - 1;
                        // Update count output every 1000 cycles
                        count <= main_counter / 1000;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        // Return to IDLE state
                        done <= 0;
                        shift_reg <= 4'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule