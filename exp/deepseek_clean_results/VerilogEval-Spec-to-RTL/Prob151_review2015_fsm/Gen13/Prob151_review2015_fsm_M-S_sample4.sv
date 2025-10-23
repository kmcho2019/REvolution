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
    localparam IDLE     = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;
    
    reg [1:0] state;
    reg [3:0] shift_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= COUNTING;
                        shift_reg <= 4'b0;  // Reset for duration bits
                    end
                end
                
                COUNTING: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (&shift_reg[2:0]) begin  // After 4 shifts (bits 0-3 filled)
                        if (done_counting) begin
                            state <= DONE;
                        end
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
    assign shift_ena = (state == COUNTING) && !(&shift_reg[2:0]);
    assign counting = (state == COUNTING) && &shift_reg[2:0];
    assign done = (state == DONE);
    
endmodule