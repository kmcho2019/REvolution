module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 256,
    parameter FULL_INIT = 1,        // 1 = initialize all locations, 0 = minimal init
    parameter REGISTERED_OUT = 0    // 0 = combinational, 1 = registered output
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout,
    input clk,                     // Optional clock for registered output
    input en                       // Optional enable for registered output
);

    // Parameterized memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Initialize memory contents
    initial begin
        // Always initialize these locations
        mem[0] = 16'hA0A0;
        mem[1] = 16'hB1B1;
        mem[2] = 16'hC2C2;
        mem[3] = 16'hD3D3;
        
        // Conditional full initialization
        if (FULL_INIT) begin
            for (integer i = 4; i < DEPTH; i = i + 1) begin
                mem[i] = {DATA_WIDTH{1'b0}};  // Initialize to zeros
            end
        end
    end

    // Internal signals
    wire [DATA_WIDTH-1:0] dout_comb = mem[addr];
    reg [DATA_WIDTH-1:0] dout_reg;

    // Output selection
    generate
        if (REGISTERED_OUT) begin
            // Registered output version
            always @(posedge clk) begin
                if (en) begin
                    dout_reg <= dout_comb;
                end
            end
            assign dout = dout_reg;
        end else begin
            // Combinational output version
            assign dout = dout_comb;
        end
    endgenerate

endmodule