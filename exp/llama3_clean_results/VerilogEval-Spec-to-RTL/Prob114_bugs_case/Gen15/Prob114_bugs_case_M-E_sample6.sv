module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    reg [3:0] rom_out;
    reg       rom_valid;

    always @(*) begin
        case (code)
            8'h45: {rom_out, rom_valid} = {4'h0, 1'b1};
            8'h16: {rom_out, rom_valid} = {4'h1, 1'b1};
            8'h1e: {rom_out, rom_valid} = {4'h2, 1'b1};
            8'h26: {rom_out, rom_valid} = {4'h3, 1'b1};
            8'h25: {rom_out, rom_valid} = {4'h4, 1'b1};
            8'h2e: {rom_out, rom_valid} = {4'h5, 1'b1};
            8'h36: {rom_out, rom_valid} = {4'h6, 1'b1};
            8'h3d: {rom_out, rom_valid} = {4'h7, 1'b1};
            8'h3e: {rom_out, rom_valid} = {4'h8, 1'b1};
            8'h46: {rom_out, rom_valid} = {4'h9, 1'b1};
            default: {rom_out, rom_valid} = {4'h0, 1'b0};
        endcase
    end

    assign out = rom_out;
    assign valid = rom_valid;

endmodule