module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg toggle; // Single-bit register to track toggled state

always @(posedge clk or posedge areset) begin
    if(areset) begin
        toggle <= 1'b0; // Reset toggle state
    end else if(x) begin
        toggle <= ~toggle; // Toggle state on x=1
    end
end

always @(*) begin
    z = toggle ? ~x : x; // Output z based on toggle state and x
end

endmodule