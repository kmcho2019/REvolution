module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam LOAD  = 4'b0010;
    localparam COUNT = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] load_count;
    reg [13:0] main_counter;  // Handles up to 16000 cycles (14 bits)
    
    // Pattern detection
    wire pattern_matched = (pattern_reg == 4'b1101);
    
    // Counter calculations
    wire [13:0] total_cycles = (delay_val + 1) * 1000;
    wire counter_done = (main_counter == 0);
    
    // Output assignments
    assign count = (state == COUNT) ? (main_counter - 1) / 1000 : 4'b0;
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            load_count <= 0;
            main_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_matched) begin
                        state <= LOAD;
                        load_count <= 0;
                    end
                end
                
                LOAD: begin
                    delay_val <= {delay_val[2:0], data};
                    load_count <= load_count + 1;
                    if (load_count == 3) begin
                        state <= COUNT;
                        main_counter <= total_cycles;
                    end
                end
                
                COUNT: begin
                    if (main_counter > 0)
                        main_counter <= main_counter - 1;
                    if (counter_done)
                        state <= DONE;
                end
                
                DONE: begin
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end

endmodule