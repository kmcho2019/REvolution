module right_shifter(
    input clk, 
    input d, 
    output reg [7:0] q
);

    initial q = 8'b0;

    always @(posedge clk) begin
        reg [7:0] temp;
        temp = q >> 1;
        temp[7] = d;
        q <= temp;
    end

endmodule