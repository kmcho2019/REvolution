module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding where the state bit directly represents the output
    reg state;  // 0=OFF, 1=ON
    
    // State register with asynchronous reset and direct next state computation
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to OFF
        else
            state <= state ? ~k : j;  // ON->(keep if ~k), OFF->(go to ON if j)
    end
    
    // Output is simply the state bit
    assign out = state;
    
endmodule