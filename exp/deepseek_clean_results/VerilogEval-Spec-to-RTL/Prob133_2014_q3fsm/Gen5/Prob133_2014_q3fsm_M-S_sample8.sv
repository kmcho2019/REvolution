module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [2:0] w_shift;  // Stores last 3 w values
    
    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;
    
    // Output logic: check for exactly two 1's in last 3 cycles
    wire z = (state == B) && (w_shift == 3'b011 || 
                             w_shift == 3'b101 || 
                             w_shift == 3'b110);
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Shift in new w value
                w_shift <= {w_shift[1:0], w};
            end else begin
                // Reset shift register when in state A
                w_shift <= 3'b000;
            end
        end
    end

endmodule