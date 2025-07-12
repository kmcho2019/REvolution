module ROM #(
    parameter ROM_SIZE = 256,
    parameter DATA_WIDTH = 16
)(
    input [31:0] addr,
    output reg [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [ROM_SIZE-1:0];

initial begin
    for (int i = 0; i < ROM_SIZE; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        // Add more initialization values as needed
    end
end

always @(*) begin
    case (addr[7:0])
        8'h00: dout = mem[0];
        8'h01: dout = mem[1];
        8'h02: dout = mem[2];
        8'h03: dout = mem[3];
        // Add more case statements for other addresses
        default: dout = 16'h0000; // Default value
    endcase
end

endmodule