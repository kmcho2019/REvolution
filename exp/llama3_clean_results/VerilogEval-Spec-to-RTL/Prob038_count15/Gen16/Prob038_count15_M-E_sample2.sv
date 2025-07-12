module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] index;

// Look-up table for the counting sequence
reg [3:0] lut [0:15];
initial begin
    for (int i = 0; i <= 15; i++) begin
        lut[i] = i;
    end
end

always @(posedge clk)
    if (reset) begin
        index <= 0;
    end else if (index == 4'd15) begin
        index <= 0;
    end else begin
        index <= index + 1;
    end

always @(*)
    q = lut[index];

endmodule