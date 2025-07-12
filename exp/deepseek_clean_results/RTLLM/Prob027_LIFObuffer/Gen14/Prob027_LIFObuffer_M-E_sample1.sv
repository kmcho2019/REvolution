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

    // Gray code encoded pointers (2 bits for 4-entry buffer)
    reg [1:0] head_ptr, tail_ptr;
    reg [1:0] head_ptr_next, tail_ptr_next;
    
    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Gray code conversion functions
    function [1:0] bin2gray(input [1:0] bin);
        bin2gray = {bin[1], bin[1] ^ bin[0]};
    endfunction
    
    function [1:0] gray2bin(input [1:0] gray);
        gray2bin = {gray[1], gray[1] ^ gray[0]};
    endfunction
    
    // Operation control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop  = EN && RW && !EMPTY;
    
    // Pointer arithmetic in binary domain
    wire [1:0] bin_head = gray2bin(head_ptr);
    wire [1:0] bin_tail = gray2bin(tail_ptr);
    
    // Flag generation
    assign EMPTY = (head_ptr == tail_ptr);
    assign FULL  = ((bin_head + 1) == bin_tail);
    
    // Next state logic (combinational)
    always @(*) begin
        // Default: hold current state
        head_ptr_next = head_ptr;
        tail_ptr_next = tail_ptr;
        
        if (Rst) begin
            head_ptr_next = 2'b00;
            tail_ptr_next = 2'b00;
        end
        else begin
            if (do_push) begin
                head_ptr_next = bin2gray(gray2bin(head_ptr) + 1);
            end
            if (do_pop) begin
                tail_ptr_next = bin2gray(gray2bin(tail_ptr) + 1);
            end
        end
    end
    
    // Sequential logic
    always @(posedge Clk) begin
        // Update pointers
        head_ptr <= head_ptr_next;
        tail_ptr <= tail_ptr_next;
        
        // Stack operations
        if (do_push) begin
            stack_mem[gray2bin(head_ptr)] <= dataIn;
        end
        if (do_pop) begin
            dataOut <= stack_mem[gray2bin(tail_ptr)];
        end
        
        // Reset condition
        if (Rst) begin
            dataOut <= 4'b0;
        end
    end

endmodule