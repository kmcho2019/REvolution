module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    // Determine next state
    if (a == 0 && b == 0) begin
        state <= ~state;
    end else if (a == 1 && b == 1) begin
        state <= ~state;
    end
    
    // Determine output q
    if (b == 1 && state == 0) begin
        q <= 1;
    end else if (a == 1 && b == 1) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule