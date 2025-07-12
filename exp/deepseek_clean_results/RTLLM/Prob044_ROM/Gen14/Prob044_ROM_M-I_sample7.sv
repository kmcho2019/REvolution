module ROM #(
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 8,
    parameter INIT_FILE = ""
)(
    input [ADDR_WIDTH-1:0] addr,
    input oe,                       // Output enable (active high)
    output wire [DATA_WIDTH-1:0] dout
);

    // Memory array declaration (2^ADDR_WIDTH x DATA_WIDTH)
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Initialize memory
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end else begin
            // Default initialization for demo
            mem[0] = 16'hA0A0;
            mem[1] = 16'hB1B1;
            mem[2] = 16'hC2C2;
            mem[3] = 16'hD3D3;
            // Initialize rest to 0
            for (integer i = 4; i < (1<<ADDR_WIDTH); i = i + 1)
                mem[i] = {DATA_WIDTH{1'b0}};
        end
    end

    // Output with enable control
    assign dout = oe ? mem[addr] : {DATA_WIDTH{1'b0}};

    /* Optional registered output for better timing
    reg [DATA_WIDTH-1:0] dout_reg;
    always @(posedge clk) begin
        if (oe)
            dout_reg <= mem[addr];
        else
            dout_reg <= {DATA_WIDTH{1'b0}};
    end
    assign dout = dout_reg;
    */

endmodule