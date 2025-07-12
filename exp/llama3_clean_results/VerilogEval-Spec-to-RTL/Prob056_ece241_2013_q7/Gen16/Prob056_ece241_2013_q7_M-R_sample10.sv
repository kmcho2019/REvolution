module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

always @(posedge clk) begin
    reg next_Q;
    
    if (j == 1'b0 && k == 1'b0) begin
        next_Q = Q;
    end else if (j == 1'b0 && k == 1'b1) begin
        next_Q = 1'b0;
    end else if (j == 1'b1 && k == 1'b0) begin
        next_Q = 1'b1;
    end else begin // j == 1'b1 && k == 1'b1
        next_Q = ~Q;
    end
    
    Q <= next_Q;
end

endmodule