module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] rom_out;
    reg [7:0] rom_addr;

    assign rom_addr = code;
    assign valid = (rom_out!= 4'd0);

    always @(*) begin
        case (rom_addr)
            8'h45: rom_out = 4'd0;
            8'h16: rom_out = 4'd1;
            8'h1e: rom_out = 4'd2;
            8'h26: rom_out = 4'd3;
            8'h25: rom_out = 4'd4;
            8'h2e: rom_out = 4'd5;
            8'h36: rom_out = 4'd6;
            8'h3d: rom_out = 4'd7;
            8'h3e: rom_out = 4'd8;
            8'h46: rom_out = 4'd9;
            default: rom_out = 4'd0;
        endcase
        out = rom_out;
    end

endmodule