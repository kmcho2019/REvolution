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
    reg [2:0] w_buffer;    // Circular buffer for w values
    reg [1:0] ptr;         // Pointer for circular buffer
    reg evaluation_flag;    // Indicates evaluation cycle
    
    // Valid patterns where exactly two 1's appear
    wire pattern1 = (w_buffer == 3'b011);
    wire pattern2 = (w_buffer == 3'b101);
    wire pattern3 = (w_buffer == 3'b110);
    wire valid_pattern = pattern1 | pattern2 | pattern3;
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_buffer <= 3'b000;
            ptr <= 2'b00;
            evaluation_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            evaluation_flag <= 1'b0;
            z <= 1'b0;  // Default output
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_buffer <= 3'b000;
                        ptr <= 2'b00;
                    end
                end
                
                B: begin
                    // Update circular buffer
                    w_buffer[ptr] <= w;
                    
                    // Update pointer (modulo 3)
                    if (ptr == 2'd2) begin
                        ptr <= 2'd0;
                        evaluation_flag <= 1'b1;
                    end else begin
                        ptr <= ptr + 1;
                    end
                    
                    // Set output if valid pattern detected
                    if (evaluation_flag) begin
                        z <= valid_pattern;
                    end
                end
            endcase
        end
    end

endmodule