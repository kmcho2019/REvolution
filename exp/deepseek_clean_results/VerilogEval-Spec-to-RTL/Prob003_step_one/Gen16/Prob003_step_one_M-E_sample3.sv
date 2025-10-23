module TopModule(output one);
    reg state;
    
    // Single-state state machine
    always @(*) begin
        state = 1'b1;  // Always in state 1
    end
    
    assign one = state;
endmodule