module ROM #(
    parameter DEPTH = 256,
    parameter WIDTH = 16
)(
    input [$clog2(DEPTH)-1:0] addr,
    output [WIDTH-1:0] dout
);

    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory contents - explicit zeros for power optimization
    integer i;
    initial begin
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        for (i = 4; i < DEPTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};  // Explicit zero initialization
        end
    end

    // Continuous read operation
    assign dout = mem[addr];

endmodule