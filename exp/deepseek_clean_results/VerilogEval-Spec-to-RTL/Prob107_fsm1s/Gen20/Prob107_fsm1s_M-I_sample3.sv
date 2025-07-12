module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    // Simplified state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else if (state == STATE_B) begin
            state <= in ? STATE_B : STATE_A;
        end else begin  // state == STATE_A
            state <= in ? STATE_A : STATE_B;
        end
    end

    // Minimal combinational output logic
    assign out = (state == STATE_B);

endmodule