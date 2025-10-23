module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] load_count;
    reg [3:0] delay_counter;
    reg [9:0] cycle_counter;  // Counts 0-999 (10 bits)
    
    wire pattern_matched = (pattern_reg == 4'b1101);
    wire load_complete = (load_count == 3);
    wire count_complete = (delay_counter == 0) && (cycle_counter == 999);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            delay_val <= 4'b0;
            load_count <= 0;
            delay_counter <= 4'b0;
            cycle_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'b0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_matched) begin
                        state <= LOAD;
                        load_count <= 0;
                        pattern_reg <= 4'b0;  // Clear after match
                    end
                end

                LOAD: begin
                    delay_val <= {delay_val[2:0], data};
                    load_count <= load_count + 1;
                    
                    if (load_complete) begin
                        state <= COUNT;
                        counting <= 1;
                        delay_counter <= delay_val;
                        cycle_counter <= 0;
                    end
                end

                COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    
                    // Count output shows current delay_counter value
                    count <= delay_counter;
                end

                DONE: begin
                    if (ack) begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule