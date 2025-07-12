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
    // Gray-coded write and read pointers
    reg [1:0] w_ptr, r_ptr;
    // Element counter (0-4)
    reg [2:0] count;

    // Gray code conversion functions
    function [1:0] bin2gray;
        input [1:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    // Combinational flag assignments
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);

    // Pointer and counter control logic
    always @(posedge Clk) begin
        if (Rst) begin
            w_ptr <= bin2gray(2'b00);
            r_ptr <= bin2gray(2'b00);
            count <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                w_ptr <= bin2gray((w_ptr[1] ^ w_ptr[0]) ? 
                         (w_ptr == 2'b11 ? 2'b00 : w_ptr + 1) : 
                         (w_ptr == 2'b00 ? 2'b11 : w_ptr - 1));
                count <= count + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                r_ptr <= bin2gray((r_ptr[1] ^ r_ptr[0]) ? 
                         (r_ptr == 2'b11 ? 2'b00 : r_ptr + 1) : 
                         (r_ptr == 2'b00 ? 2'b11 : r_ptr - 1));
                count <= count - 1;
            end
        end
    end

    // Memory and data output logic
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[w_ptr[1] ^ w_ptr[0]] <= dataIn;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[r_ptr[1] ^ r_ptr[0]];
            end
        end
    end

endmodule