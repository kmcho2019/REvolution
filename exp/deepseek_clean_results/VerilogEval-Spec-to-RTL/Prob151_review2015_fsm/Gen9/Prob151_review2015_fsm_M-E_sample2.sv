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

    // State encoding (one-hot for clarity)
    localparam IDLE    = 3'b001;
    localparam SHIFT   = 3'b010;
    localparam COUNT   = 3'b100;
    localparam DONE    = 3'b000; // Not used, DONE is implicit
    
    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [1:0] shift_counter;
    reg pattern_valid;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_counter <= 2'b0;
            pattern_valid <= 1'b0;
        end else begin
            // Default assignments
            pattern_valid <= (shift_reg == 4'b1101);
            
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (pattern_valid) begin
                        state <= SHIFT;
                        shift_counter <= 2'b0;
                    end
                end
                
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_counter == 2'b11) begin
                        state <= COUNT;
                    end else begin
                        shift_counter <= shift_counter + 1'b1;
                    end
                end
                
                COUNT: begin
                    if (done_counting) begin
                        state <= DONE;
                    end
                end
                
                default: begin // DONE state
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                        shift_counter <= 2'b0;
                    end
                end
            endcase
        end
    end
    
    // Output assignments (combinational)
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    
endmodule