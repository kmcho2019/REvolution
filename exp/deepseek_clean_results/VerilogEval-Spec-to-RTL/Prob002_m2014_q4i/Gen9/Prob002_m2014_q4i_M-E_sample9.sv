module TopModule(output out);
    // Define FSM states (only one needed)
    localparam STATE_IDLE = 1'b0;
    
    reg state;
    
    // Initialize to the only state
    initial begin
        state = STATE_IDLE;
    end
    
    // Output logic - always 0 regardless of state
    assign out = 1'b0;
    
    // No transition logic needed since there's only one state
endmodule