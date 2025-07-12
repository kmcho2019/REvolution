module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;  // Initialize to 0 for simulation
    
    always @(posedge clk) begin
        state <= in ^ state;
    end
    
    assign out = state;

endmodule