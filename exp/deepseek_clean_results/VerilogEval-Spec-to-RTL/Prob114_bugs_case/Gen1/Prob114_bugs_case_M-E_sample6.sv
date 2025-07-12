module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Pre-decoding: convert valid scancodes to sequential indices
wire [3:0] index;
assign index = (code == 8'h45) ? 4'd0 :
               (code == 8'h16) ? 4'd1 :
               (code == 8'h1e) ? 4'd2 :
               (code == 8'h26) ? 4'd3 :
               (code == 8'h25) ? 4'd4 :
               (code == 8'h2e) ? 4'd5 :
               (code == 8'h36) ? 4'd6 :
               (code == 8'h3d) ? 4'd7 :
               (code == 8'h3e) ? 4'd8 :
               (code == 8'h46) ? 4'd9 : 4'd15;

// Small ROM for output values
reg [4:0] rom [0:9]; // 4-bit output + 1-bit valid
initial begin
    rom[0] = {1'b1, 4'd0};
    rom[1] = {1'b1, 4'd1};
    rom[2] = {1'b1, 4'd2};
    rom[3] = {1'b1, 4'd3};
    rom[4] = {1'b1, 4'd4};
    rom[5] = {1'b1, 4'd5};
    rom[6] = {1'b1, 4'd6};
    rom[7] = {1'b1, 4'd7};
    rom[8] = {1'b1, 4'd8};
    rom[9] = {1'b1, 4'd9};
end

// Output logic
always @(*) begin
    if (index <= 4'd9) begin
        {valid, out} = rom[index];
    end else begin
        valid = 1'b0;
        out = 4'd0;
    end
end

endmodule