module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;  // Simulation initialization only
    /* synthesis translate_off */
    initial state = 1'b0;
    /* synthesis translate_on */
    
    wire next_state = in ^ state;
    
    assign out = state;
    
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule