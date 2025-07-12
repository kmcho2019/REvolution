module TopModule (
    input [7:0] in,
    output reg parity
);
    reg lower_parity;
    reg upper_parity;
    
    always @(*) begin
        // Compute parity for lower nibble (bits 0-3)
        lower_parity = ^in[3:0];
        
        // Compute parity for upper nibble (bits 4-7)
        upper_parity = ^in[7:4];
        
        // Combine nibble parities
        parity = lower_parity ^ upper_parity;
    end
endmodule