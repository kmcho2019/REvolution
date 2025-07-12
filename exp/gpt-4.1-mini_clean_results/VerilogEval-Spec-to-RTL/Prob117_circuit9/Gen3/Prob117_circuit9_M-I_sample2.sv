module TopModule(input clk, input a, output reg [2:0] q);

always @(posedge clk) begin
    if (a) begin
        if (q != 3'd4)
            q <= 3'd4;   // Assign 4 only if q is not already 4 to avoid redundant toggling
    end else begin
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule