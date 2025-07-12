module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNTING = 2'b10;
    localparam WAIT_ACK = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_cnt;
    reg [15:0] cycle_counter;
    reg [3:0] delay_value;

    // Pattern detection (1101)
    wire pattern_match = (pattern_reg == 4'b1101);

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == WAIT_ACK);
    assign count = (state == COUNTING) ? delay_value - (cycle_counter / 1000) : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_cnt <= 0;
            cycle_counter <= 0;
            delay_value <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_cnt <= 0;
                    end
                end

                CAPTURE: begin
                    // Shift in delay bits
                    delay_reg <= {delay_reg[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    
                    if (bit_cnt == 3) begin
                        delay_value <= delay_reg[2:0] + data;
                        // Calculate (delay+1)*1000 using shifts and adds
                        cycle_counter <= ((delay_reg[2:0] + data + 1) << 10) - 
                                        ((delay_reg[2:0] + data + 1) << 4) - 
                                        ((delay_reg[2:0] + data + 1) << 3);
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 0) begin
                        state <= WAIT_ACK;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                    end
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule