module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    wire next_state;
    
    // Next state logic using continuous assignment
    assign next_state = areset ? 1'b0 : 
                      (~state & j) ? 1'b1 :
                      (state & k) ? 1'b0 :
                      state;
    
    // State register update
    always @(posedge clk or posedge areset) begin
        state <= next_state;
    end
    
    // Output assignment
    assign out = state;
endmodule