module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // Initialize to 4
);

always @(posedge clk) begin
    if (!a) begin  // Only change when a=0
        q <= (q == 3'd4) ? 3'd5 :
             (q == 3'd5) ? 3'd6 :
             (q == 3'd6) ? 3'd0 :
             (q == 3'd0) ? 3'd1 : 3'd4;
    end
    // q remains unchanged when a=1
end

endmodule