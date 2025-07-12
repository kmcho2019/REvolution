module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;
reg [9:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
        lfsr <= 10'd1; // Initialize LFSR with a seed value
    end else begin
        // LFSR polynomial: x^10 + x^7 + 1
        lfsr <= {lfsr[9:1], lfsr[9] ^ lfsr[7] ^ lfsr[0]};
        
        if (lfsr == 10'd0) begin
            count <= 10'd0;
        end else begin
            count <= count + 10'd1;
        end
    end
end

assign q = count;

endmodule