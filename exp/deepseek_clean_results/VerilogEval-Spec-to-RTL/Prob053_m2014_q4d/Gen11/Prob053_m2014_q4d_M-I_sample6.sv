module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;  // Initialize to 0 for consistent simulation
    wire next_state = in ^ state;
    
    assign out = state;
    
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule