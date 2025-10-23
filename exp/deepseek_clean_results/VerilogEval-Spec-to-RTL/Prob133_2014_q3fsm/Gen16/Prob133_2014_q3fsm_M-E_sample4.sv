module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State tracking (A=0, B=1)
    reg state;
    
    // 3-bit shift register for w history
    reg [2:0] w_history;
    
    // State transition and shift register logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // State A
            w_history <= 3'b000;
        end else begin
            // State transition (only changes when in A and s=1)
            if (state == 1'b0)
                state <= s;
            
            // Shift register updates only in state B
            if (state == 1'b1)
                w_history <= {w_history[1:0], w};
        end
    end
    
    // Output logic - count 1's in w_history when in state B
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == 1'b1) && (ones_count == 2'd2);

endmodule