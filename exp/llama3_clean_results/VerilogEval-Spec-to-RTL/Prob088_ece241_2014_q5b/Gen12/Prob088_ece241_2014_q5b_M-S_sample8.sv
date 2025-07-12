module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) state <= 1'b1; 
    else if (!x && state) state <= 1'b1; 
    else if (x && state) state <= 1'b0; 
    else state <= 1'b0;
end

always @(*) begin
    z = (state) ? x : ~x;
end

endmodule