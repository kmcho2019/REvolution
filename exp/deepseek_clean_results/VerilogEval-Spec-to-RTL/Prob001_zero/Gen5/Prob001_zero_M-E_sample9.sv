module TopModule (
    output zero
);
    
    // Define state (though we only need one)
    reg state;
    
    // Initialize to the only state we need
    initial begin
        state = 1'b0;
    end
    
    // State machine that never changes state
    always @(*) begin
        case(state)
            1'b0: zero = 1'b0;
            default: zero = 1'b0;
        endcase
    end
    
endmodule