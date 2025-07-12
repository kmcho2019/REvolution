module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    // Free-running counter that wraps after 6
    if (counter == 3'd6)
        counter <= 3'd0;
    else
        counter <= counter + 1;
    
    // Output selection
    q <= a ? 3'd4 : counter;
end

endmodule