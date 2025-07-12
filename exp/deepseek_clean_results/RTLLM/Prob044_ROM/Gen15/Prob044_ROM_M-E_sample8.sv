module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter BANKS = 4,
    parameter BANK_DEPTH = 64
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

    // Calculate bank selection bits
    localparam BANK_SEL_WIDTH = $clog2(BANKS);
    
    // Memory banks (each with its own initialization)
    reg [DATA_WIDTH-1:0] bank0 [0:BANK_DEPTH-1];
    reg [DATA_WIDTH-1:0] bank1 [0:BANK_DEPTH-1];
    reg [DATA_WIDTH-1:0] bank2 [0:BANK_DEPTH-1];
    reg [DATA_WIDTH-1:0] bank3 [0:BANK_DEPTH-1];
    
    // Bank selection logic
    wire [BANK_SEL_WIDTH-1:0] bank_sel = addr[ADDR_WIDTH-1:ADDR_WIDTH-BANK_SEL_WIDTH];
    wire [ADDR_WIDTH-BANK_SEL_WIDTH-1:0] bank_addr = addr[ADDR_WIDTH-BANK_SEL_WIDTH-1:0];
    
    // Initialize each bank differently
    initial begin
        // Bank 0 - Linear increment pattern
        for (integer i = 0; i < BANK_DEPTH; i = i + 1)
            bank0[i] = i;
            
        // Bank 1 - Constant pattern
        for (integer i = 0; i < BANK_DEPTH; i = i + 1)
            bank1[i] = 16'hBEEF;
            
        // Bank 2 - Checkerboard pattern
        for (integer i = 0; i < BANK_DEPTH; i = i + 1)
            bank2[i] = (i % 2) ? 16'hAAAA : 16'h5555;
            
        // Bank 3 - Specific values for first 4 locations
        bank3[0] = 16'hA0A0;
        bank3[1] = 16'hB1B1;
        bank3[2] = 16'hC2C2;
        bank3[3] = 16'hD3D3;
    end
    
    // Bank multiplexer (combinational output)
    assign dout = (bank_sel == 0) ? bank0[bank_addr] :
                  (bank_sel == 1) ? bank1[bank_addr] :
                  (bank_sel == 2) ? bank2[bank_addr] :
                  bank3[bank_addr];
    
endmodule