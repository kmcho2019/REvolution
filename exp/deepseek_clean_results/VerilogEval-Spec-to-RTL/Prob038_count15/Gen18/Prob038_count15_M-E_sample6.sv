module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] counter;

// LFSR-style counter with binary sequence correction
wire feedback = counter[0];
wire [3:0] next_counter;

assign next_counter[3] = (counter == 4'b1110) ? 1'b1 : (counter[3] ^ feedback);
assign next_counter[2] = (counter == 4'b1100) ? 1'b1 : (counter[2] ^ (counter[3] & feedback));
assign next_counter[1] = (counter == 4'b1000) ? 1'b1 : (counter[1] ^ (counter[2] & counter[3] & feedback));
assign next_counter[0] = (counter == 4'b0000) ? 1'b1 : ~counter[0];

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
    end else begin
        counter <= next_counter;
    end
end

assign q = counter;

endmodule