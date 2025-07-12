module ROM(
    input [7:0] addr,
    output reg [15:0] dout
);

reg [15:0] mem [0:255];

initial begin
    for (int i = 0; i < 256; i++) begin
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
        default: dout = 16'h0000; // Default output for other addresses
    endcase
end

endmodule