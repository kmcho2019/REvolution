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
        if(count == 3'b111) begin
            count <= 3'b000;
        end else begin
            count <= count + 1;
        end
    end
end

assign out = (1 << count);

endmodule