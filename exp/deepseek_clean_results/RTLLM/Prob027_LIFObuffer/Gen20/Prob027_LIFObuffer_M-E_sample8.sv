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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Gray-coded pointers
    reg [1:0] write_ptr_gray;
    reg [1:0] read_ptr_gray;
    
    // Entry counter
    reg [2:0] count;
    
    // Gray to binary conversion
    function [1:0] gray2bin;
        input [1:0] gray;
        begin
            gray2bin[1] = gray[1];
            gray2bin[0] = gray[1] ^ gray[0];
        end
    endfunction
    
    // Binary to gray conversion
    function [1:0] bin2gray;
        input [1:0] bin;
        begin
            bin2gray[1] = bin[1];
            bin2gray[0] = bin[1] ^ bin[0];
        end
    endfunction
    
    // Get binary write pointer
    wire [1:0] write_ptr = gray2bin(write_ptr_gray);
    
    // Get binary read pointer (write_ptr-1 mod 4)
    wire [1:0] read_ptr = (write_ptr == 0) ? 2'b11 : (write_ptr - 1);
    
    // Flags
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);
    
    // Pointer update logic
    always @(posedge Clk) begin
        if (Rst) begin
            write_ptr_gray <= bin2gray(2'b00);
            count <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation
                write_ptr_gray <= bin2gray((write_ptr + 1) % 4);
                count <= count + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation
                write_ptr_gray <= bin2gray((write_ptr - 1) % 4);
                count <= count - 1;
            end
        end
    end
    
    // Data path logic
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 0;
            // Only initialize memory that will be used first
            stack_mem[0] <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation
                stack_mem[write_ptr] <= dataIn;
            end
            else if (RW && !EMPTY) begin
                // Read operation
                dataOut <= stack_mem[read_ptr];
            end
        end
    end
    
endmodule