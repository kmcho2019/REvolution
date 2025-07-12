module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter RESET_VAL = 4'b0001;
reg wrap_around;

always @(posedge clk) begin
    wrap_around <= q[3] && q[1];  // Registered comparison for 10 (1010)
    
    if (reset) begin
        q <= RESET_VAL;
    end
    else if (wrap_around) begin
        q <= RESET_VAL;
    end
    else begin
        q <= q + 1;
    end
end

endmodule