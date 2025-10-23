module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // Define states
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [2:0] w_history;    // Shift register for last 3 w values
    reg evaluate;           // Flag to indicate evaluation needed
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
            evaluate <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    // Reset all registers when in state A
                    w_history <= 3'b000;
                    evaluate <= 1'b0;
                    z <= 1'b0;
                    
                    // Transition to B when s=1
                    if (s) state <= B;
                end
                B: begin
                    // Shift in new w value
                    w_history <= {w_history[1:0], w};
                    
                    // Set evaluation flag when window is complete
                    evaluate <= (w_history[1:0] == 2'b11);  // After 3 cycles
                    
                    // Set z based on previous evaluation
                    z <= evaluate && ($countones(w_history) == 2);
                end
            endcase
        end
    end

endmodule