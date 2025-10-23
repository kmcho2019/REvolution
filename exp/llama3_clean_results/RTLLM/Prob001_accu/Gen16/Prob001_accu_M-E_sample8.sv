module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [31:0] shift_reg;
reg [1:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 0;
        count <= 0;
    end else if (valid_in) begin
        shift_reg <= {data_in, shift_reg[31:8]};
        count <= count + 1;
    end
end

wire [7:0] seg1 = shift_reg[31:24];
wire [7:0] seg2 = shift_reg[23:16];
wire [7:0] seg3 = shift_reg[15:8];
wire [7:0] seg4 = shift_reg[7:0];

wire [9:0] sum = seg1 + seg2 + seg3 + seg4;

assign valid_out = (count == 4);
assign data_out = (valid_out) ? sum : 0;

always @(posedge clk) begin
    if (valid_out) begin
        count <= 0;
    end
end

endmodule