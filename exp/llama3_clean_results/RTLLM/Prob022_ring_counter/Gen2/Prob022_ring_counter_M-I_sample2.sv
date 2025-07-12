module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 3'b000;
        out <= 8'b0000_0001;
    end else begin
        state <= state + 1;
        out <= 1 << state;
    end
end

endmodule