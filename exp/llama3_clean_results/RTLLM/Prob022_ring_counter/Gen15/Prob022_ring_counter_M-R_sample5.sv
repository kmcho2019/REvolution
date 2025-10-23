module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // Initialize state to 0
    end else begin
        state <= (state == 3'b111) ? 3'b000 : state + 1'b1; // Increment state, wrap around if necessary
    end
end

assign out[0] = (state == 3'b000);
assign out[1] = (state == 3'b001);
assign out[2] = (state == 3'b010);
assign out[3] = (state == 3'b011);
assign out[4] = (state == 3'b100);
assign out[5] = (state == 3'b101);
assign out[6] = (state == 3'b110);
assign out[7] = (state == 3'b111);

endmodule