module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

wire [1:0] lower_pos;
wire [1:0] upper_pos;
wire lower_has_one;
wire upper_has_one;

// Lower half (bits [1:0]) encoder
assign lower_has_one = |in[1:0];
assign lower_pos = in[0] ? 2'b00 : 2'b01;

// Upper half (bits [3:2]) encoder
assign upper_has_one = |in[3:2];
assign upper_pos = in[2] ? 2'b00 : 2'b01;

// Final output selection
always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // All zeros case
    end
    else if (lower_has_one) begin
        pos = lower_pos;  // Use lower half result
    end
    else begin
        pos = upper_pos + 2;  // Use upper half result with offset
    end
end

endmodule