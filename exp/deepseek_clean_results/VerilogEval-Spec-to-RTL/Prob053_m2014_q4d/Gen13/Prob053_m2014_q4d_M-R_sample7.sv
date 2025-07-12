module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    
    // Combined XOR operation and output assignment
    assign out = state;
    
    // Update state on clock edge with XOR result
    always @(posedge clk) begin
        state <= in ^ state;
    end

endmodule