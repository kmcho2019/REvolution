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

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] load_count;
    reg [9:0] fine_counter;  // Counts 0-999 (10 bits)
    reg [3:0] coarse_counter;
    wire pattern_matched;

    // Pattern detection
    assign pattern_matched = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            delay_val <= 4'b0;
            load_count <= 0;
            fine_counter <= 0;
            coarse_counter <= 0;
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
                        pattern_reg <= 4'b0;  // Clear to prevent false detection
                    end
                end

                LOAD: begin
                    if (load_count < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        load_count <= load_count + 1;
                    end else begin
                        state <= COUNT;
                        counting <= 1;
                        coarse_counter <= delay_val;
                        fine_counter <= 0;
                    end
                end

                COUNT: begin
                    if (fine_counter == 999) begin
                        fine_counter <= 0;
                        if (coarse_counter == 0) begin
                            state <= IDLE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            coarse_counter <= coarse_counter - 1;
                        end
                    end else begin
                        fine_counter <= fine_counter + 1;
                    end
                    
                    count <= coarse_counter;
                    
                    // Handle done acknowledgment
                    if (done && ack) begin
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule