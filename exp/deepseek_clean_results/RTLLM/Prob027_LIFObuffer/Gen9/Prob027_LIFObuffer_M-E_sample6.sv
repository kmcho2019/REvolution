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
    
    // Gray-coded pointers (2 bits each)
    reg [1:0] wr_ptr, rd_ptr;
    
    // Track last operation (0 = write, 1 = read)
    reg last_op;
    
    // Convert gray code to binary for address calculation
    function [1:0] gray2bin;
        input [1:0] gray;
        begin
            gray2bin[1] = gray[1];
            gray2bin[0] = gray[1] ^ gray[0];
        end
    endfunction
    
    // Combinational flags
    assign EMPTY = (wr_ptr == rd_ptr) && !last_op;
    assign FULL = (wr_ptr == rd_ptr) && last_op;
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all pointers and clear last operation
            wr_ptr <= 2'b00;
            rd_ptr <= 2'b00;
            last_op <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[gray2bin(wr_ptr)] <= dataIn;
                // Update write pointer (gray code sequence: 00->01->11->10)
                case (wr_ptr)
                    2'b00: wr_ptr <= 2'b01;
                    2'b01: wr_ptr <= 2'b11;
                    2'b11: wr_ptr <= 2'b10;
                    2'b10: wr_ptr <= 2'b00;
                endcase
                last_op <= 1'b0;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[gray2bin(rd_ptr)];
                // Update read pointer (same gray code sequence)
                case (rd_ptr)
                    2'b00: rd_ptr <= 2'b01;
                    2'b01: rd_ptr <= 2'b11;
                    2'b11: rd_ptr <= 2'b10;
                    2'b10: rd_ptr <= 2'b00;
                endcase
                last_op <= 1'b1;
            end
        end
    end

endmodule