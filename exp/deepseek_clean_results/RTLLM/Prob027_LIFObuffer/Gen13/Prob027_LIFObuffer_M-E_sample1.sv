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

    // Memory organized as circular buffer (4 entries, 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Gray-coded pointers (2 bits each)
    reg [1:0] w_ptr, r_ptr;
    
    // Pointer difference tracking
    reg [2:0] count;
    
    // Pre-computed flags (registered)
    reg empty_flag, full_flag;
    
    // Gray code conversion functions
    function [1:0] bin2gray;
        input [1:0] bin;
        begin
            bin2gray = {bin[1], bin[1] ^ bin[0]};
        end
    endfunction
    
    function [1:0] gray2bin;
        input [1:0] gray;
        begin
            gray2bin = {gray[1], gray[1] ^ gray[0]};
        end
    endfunction
    
    // Combinational outputs
    assign EMPTY = empty_flag;
    assign FULL = full_flag;
    
    // Next state flag calculation
    wire next_empty = (count == 0) && (RW || !EN);
    wire next_full = (count == 4) && (!RW || !EN);
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Partial reset - only clear pointers and flags
            w_ptr <= 2'b00;
            r_ptr <= 2'b00;
            count <= 3'b000;
            empty_flag <= 1'b1;
            full_flag <= 1'b0;
            dataOut <= 4'b0;
            
            // Only clear the first memory location (others cleared on demand)
            stack_mem[0] <= 4'b0;
        end
        else if (EN) begin
            // Update flags one cycle ahead
            empty_flag <= next_empty;
            full_flag <= next_full;
            
            if (!RW && !full_flag) begin
                // Write operation (push)
                stack_mem[gray2bin(w_ptr)] <= dataIn;
                w_ptr <= bin2gray(gray2bin(w_ptr) + 1);
                count <= count + 1;
            end
            else if (RW && !empty_flag) begin
                // Read operation (pop)
                dataOut <= stack_mem[gray2bin(r_ptr)];
                r_ptr <= bin2gray(gray2bin(r_ptr) + 1);
                count <= count - 1;
            end
        end
    end
    
    // Initialize remaining memory locations to X (will be overwritten before use)
    initial begin
        stack_mem[1] = 4'bx;
        stack_mem[2] = 4'bx;
        stack_mem[3] = 4'bx;
    end

endmodule