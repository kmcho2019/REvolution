module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [1:0] buf_ptr;      // Circular buffer pointer (0-2)
    reg [2:0] w_buffer;     // Circular buffer for w values
    reg eval_trigger;       // Marks when to evaluate
    
    // Parallel pattern detection wires
    wire pattern1 = w_buffer[0] & w_buffer[1] & ~w_buffer[2];
    wire pattern2 = w_buffer[0] & ~w_buffer[1] & w_buffer[2];
    wire pattern3 = ~w_buffer[0] & w_buffer[1] & w_buffer[2];
    wire two_ones = pattern1 | pattern2 | pattern3;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            buf_ptr <= 2'b00;
            w_buffer <= 3'b000;
            eval_trigger <= 1'b0;
            z <= 1'b0;
        end else begin
            // Default assignments
            eval_trigger <= 1'b0;
            z <= 1'b0;
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        buf_ptr <= 2'b00;
                        w_buffer <= 3'b000;
                    end
                end
                
                B: begin
                    // Update circular buffer
                    w_buffer[buf_ptr] <= w;
                    
                    // Pointer wraps around after 2
                    if (buf_ptr == 2'b10) begin
                        buf_ptr <= 2'b00;
                        eval_trigger <= 1'b1;  // Trigger evaluation next cycle
                    end else begin
                        buf_ptr <= buf_ptr + 1;
                    end
                    
                    // Output is registered version of evaluation
                    z <= eval_trigger & two_ones;
                end
            endcase
        end
    end

endmodule