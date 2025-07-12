module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter RESET_VAL = 4'b0001;
reg wrap;

always @(posedge clk) begin
    wrap <= (q == 4'b1010);  // Registered comparison for '10'
    
    if (reset) begin
        q <= RESET_VAL;
    end
    else if (wrap) begin
        q <= RESET_VAL;
    end
    else begin
        q <= q + 4'b0001;
    end
end

endmodule