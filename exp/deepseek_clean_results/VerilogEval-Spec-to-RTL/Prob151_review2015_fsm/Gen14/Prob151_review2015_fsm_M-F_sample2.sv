module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 4'b0001;
    localparam SHIFT   = 4'b0010;
    localparam COUNT   = 4'b0100;
    localparam DONE    = 4'b1000;
    
    reg [3:0] state;
    reg [3:0] shift_reg;
    reg [1:0] shift_counter;
    reg [1:0] pattern_counter;
    
    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_counter <= 2'b0;
            pattern_counter <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    pattern_counter <= pattern_counter + 1'b1;
                    
                    if (pattern_counter == 2'b11 && shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_counter <= 2'b0;
                        shift_reg <= 4'b0; // Clear for duration bits
                    end
                end
                
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    shift_counter <= shift_counter + 1'b1;
                    
                    if (shift_counter == 2'b11) begin
                        state <= COUNT;
                    end
                end
                
                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_counter <= 2'b0;
                    end
                end
            endcase
        end
    end
    
    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    
endmodule