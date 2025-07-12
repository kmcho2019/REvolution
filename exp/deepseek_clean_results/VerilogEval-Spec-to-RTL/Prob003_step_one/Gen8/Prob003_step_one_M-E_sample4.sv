module TopModule (
    output one
);
    // Single-state state machine that always outputs 1
    typedef enum logic {S1 = 1'b1} state_t;
    state_t state;
    
    // Combinational output assignment
    assign one = state;
    
    // State transition (though it never actually changes)
    always_comb begin
        state = S1;  // Always stay in state S1 which outputs 1
    end
endmodule