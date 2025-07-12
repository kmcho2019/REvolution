module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter REGISTER_OUTPUT = 0
) (
    input [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

    // Function to generate ROM content based on address
    function [DATA_WIDTH-1:0] rom_content;
        input [ADDR_WIDTH-1:0] address;
        begin
            case(address)
                8'd0: rom_content = 16'hA0A0;
                8'd1: rom_content = 16'hB1B1;
                8'd2: rom_content = 16'hC2C2;
                8'd3: rom_content = 16'hD3D3;
                default: begin
                    // Generate deterministic pseudo-random pattern
                    rom_content = {address, ~address} ^ 
                                 {address[3:0], address[7:4]} ^ 
                                 {DATA_WIDTH{address[0]}};
                end
            endcase
        end
    endfunction

    // Combinational output or registered output
    generate
        if (REGISTER_OUTPUT) begin
            reg [DATA_WIDTH-1:0] dout_reg;
            always @(*) dout_reg = rom_content(addr);
            always @(posedge clk) dout <= dout_reg;
        end else begin
            always @(*) dout = rom_content(addr);
        end
    endgenerate

endmodule