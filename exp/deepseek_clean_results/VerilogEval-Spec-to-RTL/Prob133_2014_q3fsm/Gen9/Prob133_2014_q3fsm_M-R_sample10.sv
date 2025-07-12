module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [2:0] w_history;    // Shift register for w values (also tracks window)
    
    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;
    
    // Output logic - active when window is full (w_history[2] is oldest bit)
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == B) && (&w_history !== 1'bx) && (ones_count == 2'd2);
    
    // Sequential logic (single always block)
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                w_history <= {w_history[1:0], w};  // Shift in new w value
            end else begin
                w_history <= 3'b000;  // Clear when in state A
            end
        end
    end

endmodule