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

    // State encoding
    localparam IDLE    = 2'b00;
    localparam SHIFT   = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;
    
    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [1:0] shift_counter;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            shift_counter <= 2'b0;
        end else begin
            // Always shift in new data
            shift_reg <= {shift_reg[2:0], data};
            
            case (state)
                IDLE: begin
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_counter <= 2'b0;
                    end
                end
                
                SHIFT: begin
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
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
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