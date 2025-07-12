module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

initial begin
    for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
        if (i == 0) mem[i] = 16'hA0A0;
        else if (i == 1) mem[i] = 16'hB1B1;
        else if (i == 2) mem[i] = 16'hC2C2;
        else if (i == 3) mem[i] = 16'hD3D3;
        else mem[i] = 16'h0000; // Initialize other locations with a default value
    end
end

always @(*) begin
    case (addr)
        8'd0: dout = mem[0];
        8'd1: dout = mem[1];
        8'd2: dout = mem[2];
        8'd3: dout = mem[3];
        default: dout = 16'h0000; // Handle invalid addresses
    endcase
end

endmodule