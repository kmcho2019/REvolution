module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] lfsr;
reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 10'd1; // Initial seed
    end else begin
        lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[0]}; // LFSR update
    end
end

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
    end else if (lfsr == 10'd1000) begin
        count <= 10'd0;
    end else begin
        count <= count + 10'd1;
    end
end

assign q = count;

endmodule