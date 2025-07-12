module TopModule (
    input [7:0] in,
    output reg parity
);
    reg parity_lower;
    reg parity_upper;
    
    always @(*) begin
        // Compute lower nibble parity (bits 3:0)
        parity_lower = ^in[3:0];
        
        // Compute upper nibble parity (bits 7:4)
        parity_upper = ^in[7:4];
        
        // Combine results
        parity = parity_lower ^ parity_upper;
    end
endmodule