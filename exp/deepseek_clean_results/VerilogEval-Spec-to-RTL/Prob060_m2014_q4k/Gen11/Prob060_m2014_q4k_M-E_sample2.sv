module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [1:0] state;
    reg delayed_in;
    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= 2'b0;
            delayed_in <= 1'b0;
        end
        else begin
            // Main state transition on positive edge
            state <= {state[0], in ^ state[1]};
        end
    end
    
    always @(negedge clk) begin
        if (resetn) begin
            // Capture intermediate value on negative edge
            delayed_in <= in;
        end
    end
    
    // Output combines current state and delayed input
    assign out = (state[1] & delayed_in) | (state[0] ^ delayed_in);

endmodule