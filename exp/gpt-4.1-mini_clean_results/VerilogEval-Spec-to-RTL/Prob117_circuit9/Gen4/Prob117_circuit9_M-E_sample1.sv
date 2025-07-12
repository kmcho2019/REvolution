module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    // Counter increments modulo 7 continuously
    counter <= (counter == 3'd6) ? 3'd0 : counter + 3'd1;
    
    // Output q forced to 4 when a=1, else shows counter
    if (a)
        q <= 3'd4;
    else
        q <= counter;
end

endmodule