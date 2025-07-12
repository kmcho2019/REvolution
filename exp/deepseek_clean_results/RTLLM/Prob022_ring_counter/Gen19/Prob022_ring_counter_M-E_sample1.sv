module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos_counter;

always @(posedge clk) begin
    if (reset) begin
        pos_counter <= 3'b000;
    end else begin
        pos_counter <= pos_counter + 1;
    end
end

always @(*) begin
    out = 8'b00000000;
    out[pos_counter] = 1'b1;
end

endmodule