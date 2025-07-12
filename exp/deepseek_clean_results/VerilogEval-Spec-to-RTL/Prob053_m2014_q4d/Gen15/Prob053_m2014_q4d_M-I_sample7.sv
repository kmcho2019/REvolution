module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;  // Explicit initialization for simulation
    wire next_state = in ^ state;
    
    assign out = state;
    
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule