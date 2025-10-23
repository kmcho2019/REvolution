module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] count;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        count <= 3'b000;
    end else begin
        count <= (count == 3'b111) ? 3'b000 : count + 1;
    end

    out <= (1 << count);
end

endmodule