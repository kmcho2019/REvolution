module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] address;

always @(posedge clk) begin
    if (reset) begin
        address <= 4'd0;
    end else if (address == 4'd9) begin
        address <= 4'd0;
    end else begin
        address <= address + 4'd1;
    end
end

// ROM to store the decade count sequence
reg [3:0] rom_output;
always @(*) begin
    case (address)
        4'd0: rom_output = 4'd0;
        4'd1: rom_output = 4'd1;
        4'd2: rom_output = 4'd2;
        4'd3: rom_output = 4'd3;
        4'd4: rom_output = 4'd4;
        4'd5: rom_output = 4'd5;
        4'd6: rom_output = 4'd6;
        4'd7: rom_output = 4'd7;
        4'd8: rom_output = 4'd8;
        4'd9: rom_output = 4'd9;
        default: rom_output = 4'd0;
    endcase
end

assign q = rom_output;

endmodule