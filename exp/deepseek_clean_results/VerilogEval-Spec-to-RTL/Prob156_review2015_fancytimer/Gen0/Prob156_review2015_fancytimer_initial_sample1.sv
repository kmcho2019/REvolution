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
    localparam IDLE       = 2'b00;
    localparam SHIFT_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // For detecting 1101
    reg [3:0] delay_reg;    // Stores the delay value
    reg [2:0] shift_count;  // Counts 4 bits for delay
    reg [13:0] main_counter; // Counts up to (15+1)*1000=16000
    reg [9:0] sub_counter;  // Counts 1000 cycles for each delay step

    // Pattern detection and FSM transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_count <= 3'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                
                SHIFT_DELAY: begin
                    if (shift_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        shift_count <= shift_count + 1;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                
                COUNTING: begin
                    if (sub_counter == 999) begin
                        sub_counter <= 0;
                        if (main_counter == 0) begin
                            next_state <= DONE;
                        end else begin
                            count <= count - 1;
                        end
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end
                    
                    if (main_counter > 0) begin
                        main_counter <= main_counter - 1;
                    end
                    counting <= 1'b1;
                    done <= 1'b0;
                end
                
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        next_state <= IDLE;
                        pattern_reg <= 4'b0;
                        shift_count <= 3'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT_DELAY;
                end
            end
            
            SHIFT_DELAY: begin
                if (shift_count == 4) begin
                    next_state = COUNTING;
                    // Initialize counters
                    main_counter = (delay_reg + 1) * 1000 - 1;
                    sub_counter = 0;
                    count = delay_reg;
                end
            end
            
            COUNTING: begin
                if (main_counter == 0 && sub_counter == 999) begin
                    next_state = DONE;
                end
            end
            
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule