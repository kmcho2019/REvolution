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
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] shift_reg;      // For pattern and delay capture
    reg [13:0] main_counter;  // Handles up to 16*1000 cycles
    reg [3:0] delay_value;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            main_counter <= 0;
            delay_value <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    
                    // Detect 1101 pattern
                    if (shift_reg == 4'b1101) begin
                        state <= COUNTING;
                        main_counter <= 0;
                    end
                end
                
                COUNTING: begin
                    // First 4 cycles after pattern capture delay value
                    if (main_counter < 4) begin
                        delay_value <= {delay_value[2:0], data};
                        main_counter <= main_counter + 1;
                    end 
                    // Count (delay+1)*1000 cycles
                    else if (main_counter < (delay_value + 1) * 1000 + 3) begin
                        main_counter <= main_counter + 1;
                    end
                    else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        counting = (state == COUNTING) && (main_counter >= 4);
        done = (state == DONE);
        
        if (state == COUNTING && main_counter >= 4) begin
            count = delay_value - ((main_counter - 4) / 1000);
        end else begin
            count = 4'b0;  // Don't care when not counting
        end
    end

endmodule