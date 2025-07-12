module TopModule (
    input clk,
    input reset,
    input x,
    input y,
    output reg z
);
    wire comb_z;
    
    // Combinational logic
    assign comb_z = x & ~y;
    
    // Sequential registration
    always @(posedge clk or posedge reset) begin
        if (reset)
            z <= 1'b0;
        else
            z <= comb_z;
    end
endmodule