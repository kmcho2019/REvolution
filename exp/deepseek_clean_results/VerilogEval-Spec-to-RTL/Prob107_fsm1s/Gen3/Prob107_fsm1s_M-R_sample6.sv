module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;
    wire next_state;

    // State transition logic
    assign next_state = (state == STATE_B) ? (in ? STATE_B : STATE_A) : 
                                       (in ? STATE_A : STATE_B);

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Output logic
    assign out = (state == STATE_B);

endmodule