module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] next_state;

always @(*) begin
    if(reset) begin
        next_state = 8'b0000_0001;
    end else begin
        next_state = {out[6:0], out[7]};
    end
end

always @(posedge clk) begin
    if(reset) begin
        out <= 8'b0000_0001;
    end else begin
        out <= next_state;
    end
end

endmodule