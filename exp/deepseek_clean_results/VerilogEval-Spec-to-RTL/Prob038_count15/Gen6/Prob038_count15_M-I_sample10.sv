module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;
wire counter_enable;

// Clock gating control (enable counting unless we're at max value)
assign counter_enable = (count != 4'b1111) || reset;

// Carry-chain style incrementer for better timing
assign next_count[0] = ~count[0];
assign next_count[1] = count[1] ^ count[0];
assign next_count[2] = count[2] ^ (&count[1:0]);
assign next_count[3] = count[3] ^ (&count[2:0]);

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (counter_enable) begin
        count <= next_count;
    end
end

assign q = count;

endmodule