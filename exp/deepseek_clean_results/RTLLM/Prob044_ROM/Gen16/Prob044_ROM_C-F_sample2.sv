module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256,
    parameter REGISTER_OUTPUT = 0  // 0: combinational, 1: registered
)(
    input [ADDR_WIDTH-1:0] addr,
    input en,                      // Enable signal
    output [DATA_WIDTH-1:0] dout
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Internal signals
    reg [DATA_WIDTH-1:0] dout_comb;
    reg [DATA_WIDTH-1:0] dout_reg;

    // Initialize memory (default zeros)
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = {DATA_WIDTH{1'b0}};
            
        // Custom initialization
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
    end

    // Combinational read with enable
    always @(*) begin
        dout_comb = en ? mem[addr] : {DATA_WIDTH{1'b0}};
    end

    // Optional output register
    generate
        if (REGISTER_OUTPUT) begin
            always @(posedge clk) begin
                dout_reg <= dout_comb;
            end
            assign dout = dout_reg;
        end else begin
            assign dout = dout_comb;
        end
    endgenerate

endmodule