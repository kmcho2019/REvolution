module TopModule (
    output out
);
    reg state;
    
    always @(*) begin
        state = 1'b0;  // Always transition to state 0
    end
    
    assign out = 1'b0; // Output is always 0 regardless of state
endmodule