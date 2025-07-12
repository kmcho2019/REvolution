module TopModule(output one);
    reg state = 1'b1;
    assign one = state;
    
    // This always block represents a state machine that never changes state
    always @(*) begin
        state = 1'b1; // Permanent state
    end
endmodule