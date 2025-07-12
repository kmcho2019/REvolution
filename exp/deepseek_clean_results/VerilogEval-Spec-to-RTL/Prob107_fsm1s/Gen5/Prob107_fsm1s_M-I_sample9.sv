module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= (state == STATE_B) ? (in ? STATE_B : STATE_A) : 
                                        (in ? STATE_A : STATE_B);
    end

    // Output is simply the inverse of state (since STATE_B=0 outputs 1)
    assign out = ~state;

endmodule