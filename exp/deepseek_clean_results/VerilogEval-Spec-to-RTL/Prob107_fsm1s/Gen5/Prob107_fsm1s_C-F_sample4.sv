module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= state ? in : ~in;  // Compact state transition
    end

    assign out = (state == STATE_B);  // Clear output logic

endmodule