module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Gray-coded pointers
    reg [2:0] write_ptr, read_ptr;
    // Stack depth counter
    reg [2:0] depth;
    
    // Gray code conversion functions
    function [2:0] bin2gray(input [2:0] bin);
        return bin ^ (bin >> 1);
    endfunction
    
    function [2:0] gray2bin(input [2:0] gray);
        return {gray[2], 
                gray[2] ^ gray[1],
                gray[2] ^ gray[1] ^ gray[0]};
    endfunction

    // Operation validation
    wire write_op = EN && !RW && !FULL;
    wire read_op = EN && RW && !EMPTY;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and clear flags
            write_ptr <= 3'b000;
            read_ptr <= 3'b000;
            depth <= 3'b000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else begin
            // Handle write operations
            if (write_op) begin
                stack_mem[gray2bin(write_ptr)] <= dataIn;
                write_ptr <= bin2gray((gray2bin(write_ptr) + 1) % 4);
                depth <= depth + 1;
            end
            
            // Handle read operations
            if (read_op) begin
                dataOut <= stack_mem[gray2bin(read_ptr)];
                read_ptr <= bin2gray((gray2bin(read_ptr) + 1) % 4);
                depth <= depth - 1;
            end
            
            // Update flags (combinatorial but registered)
            EMPTY <= (depth == 0);
            FULL <= (depth == 4);
        end
    end

    // Power gating control for unused memory locations
    always @(*) begin
        // Disable unused memory locations to save power
        for (integer i = 0; i < 4; i = i + 1) begin
            if (i >= gray2bin(read_ptr) && i < gray2bin(write_ptr)) begin
                stack_mem[i] = stack_mem[i]; // Active
            end else begin
                stack_mem[i] = 4'bxxxx; // High-impedance when unused
            end
        end
    end

endmodule