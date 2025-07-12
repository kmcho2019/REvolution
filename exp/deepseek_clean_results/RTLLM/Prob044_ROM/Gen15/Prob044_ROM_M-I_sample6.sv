module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256
)(
    input wire en,                     // Enable signal for power saving
    input wire [ADDR_WIDTH-1:0] addr,
    output wire [DATA_WIDTH-1:0] dout  // Changed to wire for combinational output
);

    // Parameterized memory array with block RAM hint
    (* ram_style = "block" *) reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize all memory locations to zero for predictable behavior
    initial begin
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_WIDTH{1'b0}};
        end
        // Override specific locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Gated combinational read
    assign dout = en ? mem[addr] : {DATA_WIDTH{1'b0}};

endmodule