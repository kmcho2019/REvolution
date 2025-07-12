module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam SEARCH      = 2'b00;
    localparam CAPTURE     = 2'b01;
    localparam COUNTING    = 2'b10;
    localparam WAIT_ACK    = 2'b11;
    
    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_count;
    reg [15:0] main_counter; // Enough for 16*1000 = 16000 cycles
    
    // Pattern match detection
    wire pattern_match = (pattern_reg == 4'b1101);
    
    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == WAIT_ACK);
    assign count = (state == COUNTING) ? (main_counter / 1000) : 4'b0;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 0;
            main_counter <= 0;
        end else begin
            case (state)
                SEARCH: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_count <= 0;
                    end
                end
                
                CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3) begin
                        state <= COUNTING;
                        main_counter <= (delay_reg + 1) * 1000 - 1;
                    end
                end
                
                COUNTING: begin
                    if (main_counter == 0) begin
                        state <= WAIT_ACK;
                    end else begin
                        main_counter <= main_counter - 1;
                    end
                end
                
                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule