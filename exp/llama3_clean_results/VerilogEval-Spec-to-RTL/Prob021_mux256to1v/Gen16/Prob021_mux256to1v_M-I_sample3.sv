module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Split the 8-bit selector into block selector (4 bits) and address (4 bits)
wire [3:0] block_sel = sel[7:4];
wire [3:0] addr = sel[3:0];

// Use a case statement to decode the block selector and select the correct memory block
reg [63:0] selected_block;
always @(*) begin
    case (block_sel)
        4'd0: selected_block = in[63:0];
        4'd1: selected_block = in[127:64];
        4'd2: selected_block = in[191:128];
        4'd3: selected_block = in[255:192];
        4'd4: selected_block = in[319:256];
        4'd5: selected_block = in[383:320];
        4'd6: selected_block = in[447:384];
        4'd7: selected_block = in[511:448];
        4'd8: selected_block = in[575:512];
        4'd9: selected_block = in[639:576];
        4'd10: selected_block = in[703:640];
        4'd11: selected_block = in[767:704];
        4'd12: selected_block = in[831:768];
        4'd13: selected_block = in[895:832];
        4'd14: selected_block = in[959:896];
        4'd15: selected_block = in[1023:960];
        default: selected_block = 64'd0;
    endcase
end

// Use indexing to select the correct 4-bit value from the chosen block
assign out = selected_block[(addr * 4) +: 4];

endmodule