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
    reg [1:0] load_count;
    reg [13:0] main_counter;  // Handles up to 16000 cycles (14 bits)
    
    wire pattern_matched = (pattern_reg == 4'b1101);
    wire load_complete = (load_count == 3);
    wire count_complete = (main_counter == (delay_val + 1) * 1000 - 1);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            delay_val <= 4'b0;
            load_count <= 0;
            main_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'b0;
                    main_counter <= 0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_matched) begin
                        state <= LOAD;
                        load_count <= 0;
                        pattern_reg <= 4'b0;
                    end
                end

                LOAD: begin
                    delay_val <= {delay_val[2:0], data};
                    load_count <= load_count + 1;
                    
                    if (load_complete) begin
                        state <= COUNT;
                        counting <= 1;
                        main_counter <= 0;
                    end
                end

                COUNT: begin
                    if (count_complete) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        main_counter <= main_counter + 1;
                    end
                    
                    // Update count output based on remaining time
                    count <= delay_val - (main_counter / 1000);
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