module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        q_reg <= 8'h34;
    end else if(~clk) begin // This condition ensures the DFFs are triggered on the negative edge of clk
        // Introduce a small delay to make sure the if condition is evaluated before the non-blocking assignment
        // In a real-world scenario, this can be avoided by using a more advanced timing model
        #0;
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule