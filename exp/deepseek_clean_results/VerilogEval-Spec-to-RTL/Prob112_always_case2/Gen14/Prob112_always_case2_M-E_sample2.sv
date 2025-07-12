module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

wire [1:0] lower_pair = in[1:0];
wire [1:0] upper_pair = in[3:2];

wire lower_valid = |lower_pair;
wire upper_valid = |upper_pair;

wire [0:0] lower_pos = lower_pair[1] ? 1'b1 : 1'b0;
wire [0:0] upper_pos = upper_pair[1] ? 1'b1 : 1'b0;

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // All zeros case
    end
    else if (lower_valid) begin
        pos = {1'b0, lower_pos};  // Position in lower pair
    end
    else begin
        pos = {1'b1, upper_pos};  // Position in upper pair
    end
end

endmodule