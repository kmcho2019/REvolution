module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output valid
);

wire [9:0] one_hot;

// Generate one-hot signals for each recognized scancode
assign one_hot[0] = (code == 8'h45); // key '0'
assign one_hot[1] = (code == 8'h16); // key '1'
assign one_hot[2] = (code == 8'h1E); // key '2'
assign one_hot[3] = (code == 8'h26); // key '3'
assign one_hot[4] = (code == 8'h25); // key '4'
assign one_hot[5] = (code == 8'h2E); // key '5'
assign one_hot[6] = (code == 8'h36); // key '6'
assign one_hot[7] = (code == 8'h3D); // key '7'
assign one_hot[8] = (code == 8'h3E); // key '8'
assign one_hot[9] = (code == 8'h46); // key '9'

assign valid = |one_hot; // valid if any recognized code matched

always @(*) begin
    casez(one_hot)
        10'b0000000001: out = 4'd0;
        10'b0000000010: out = 4'd1;
        10'b0000000100: out = 4'd2;
        10'b0000001000: out = 4'd3;
        10'b0000010000: out = 4'd4;
        10'b0000100000: out = 4'd5;
        10'b0001000000: out = 4'd6;
        10'b0010000000: out = 4'd7;
        10'b0100000000: out = 4'd8;
        10'b1000000000: out = 4'd9;
        default:        out = 4'd0; // default output if no valid code
    endcase
end

endmodule