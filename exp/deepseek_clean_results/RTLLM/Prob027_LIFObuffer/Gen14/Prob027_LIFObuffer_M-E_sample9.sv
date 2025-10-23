module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Gray-encoded pointers (3 bits for 4 entries)
    reg [2:0] WP, RP;
    
    // Gray code increment function
    function [2:0] gray_inc;
        input [2:0] gray;
        reg [2:0] bin;
        begin
            bin = gray ^ (gray >> 1); // Convert to binary
            bin = bin + 1;             // Increment
            gray_inc = bin ^ (bin >> 1); // Convert back to gray
        end
    endfunction
    
    // Gray code decrement function
    function [2:0] gray_dec;
        input [2:0] gray;
        reg [2:0] bin;
        begin
            bin = gray ^ (gray >> 1); // Convert to binary
            bin = bin - 1;             // Decrement
            gray_dec = bin ^ (bin >> 1); // Convert back to gray
        end
    endfunction
    
    // Pointer difference calculation
    function [2:0] ptr_diff;
        input [2:0] ptr_a, ptr_b;
        reg [2:0] bin_a, bin_b;
        begin
            bin_a = ptr_a ^ (ptr_a >> 1); // Convert to binary
            bin_b = ptr_b ^ (ptr_b >> 1); // Convert to binary
            ptr_diff = bin_a - bin_b;
        end
    endfunction
    
    // Flags
    assign EMPTY = (ptr_diff(WP, RP) == 0);
    assign FULL = (ptr_diff(WP, RP) == 4;
    
    // Bypass path for simultaneous read-after-write
    wire [3:0] bypass_data = (EN && !RW && !FULL && (ptr_diff(gray_inc(WP), RP) == 1) ? 
                            dataIn : stack_mem[RP[1:0]];

    always @(posedge Clk) begin
        if (Rst) begin
            WP <= 3'b000;
            RP <= 3'b000;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation
                stack_mem[WP[1:0]] <= dataIn;
                WP <= gray_inc(WP);
            end
            else if (RW && !EMPTY) begin
                // Read operation
                dataOut <= bypass_data;
                RP <= gray_inc(RP);
            end
        end
    end

endmodule