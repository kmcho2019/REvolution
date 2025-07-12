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

    // Memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Gray-coded pointers (2 bits each)
    reg [1:0] w_ptr, r_ptr;
    
    // Gray code conversion functions
    function [1:0] bin2gray(input [1:0] bin);
        bin2gray = {bin[1], bin[1] ^ bin[0]};
    endfunction
    
    function [1:0] gray2bin(input [1:0] gray);
        gray2bin = {gray[1], gray[1] ^ gray[0]};
    endfunction
    
    // Pointer arithmetic
    wire [1:0] w_ptr_plus1 = gray2bin(w_ptr) + 1;
    wire [1:0] r_ptr_plus1 = gray2bin(r_ptr) + 1;
    
    // Status flags
    assign EMPTY = (w_ptr == r_ptr);
    assign FULL = (w_ptr_plus1 == r_ptr);
    
    // Operation control
    wire do_push = EN && !RW && !FULL;
    wire do_pop = EN && RW && !EMPTY;
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset pointers to same value (empty)
            w_ptr <= bin2gray(2'b00);
            r_ptr <= bin2gray(2'b00);
            dataOut <= 4'b0;
            
            // Optional: Clear memory (comment out for power optimization)
            // stack_mem[0] <= 4'b0;
            // stack_mem[1] <= 4'b0;
            // stack_mem[2] <= 4'b0;
            // stack_mem[3] <= 4'b0;
        end
        else begin
            // Push operation
            if (do_push) begin
                stack_mem[gray2bin(w_ptr)] <= dataIn;
                w_ptr <= bin2gray(w_ptr_plus1);
            end
            
            // Pop operation
            if (do_pop) begin
                dataOut <= stack_mem[gray2bin(r_ptr)];
                r_ptr <= bin2gray(r_ptr_plus1);
            end
        end
    end

endmodule