module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        // Optimized hybrid approach
        // Efficient LFSR-style for lower bits
        count[0] <= ~count[0];
        count[1] <= count[0] ? ~count[1] : count[1];
        
        // Arithmetic for higher bits to avoid timing issues
        if (count[1:0] == 2'b11) begin
            count[3:2] <= count[3:2] + 1'b1;
        end
    end
end

assign q = count;

endmodule