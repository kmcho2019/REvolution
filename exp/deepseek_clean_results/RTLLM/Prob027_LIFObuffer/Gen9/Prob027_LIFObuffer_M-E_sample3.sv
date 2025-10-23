module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output wire [3:0] dataOut
);

    // Memory array with clock gating
    reg [3:0] stack_mem [0:3];
    wire mem_clk = Clk & EN;
    
    // Gray-coded circular stack pointer (2 bits + wrap bit)
    reg [2:0] SP_gray;
    wire [2:0] next_SP_gray;
    
    // Status register (bit3:empty, bit2:full, bit1:last_op, bit0:op_valid)
    reg [3:0] status;
    
    // Shadow output register
    reg [3:0] dataOut_reg;
    
    // Gray code conversions
    function [2:0] bin2gray(input [2:0] b);
        bin2gray = {b[2], b[2:1] ^ b[1:0]};
    endfunction
    
    function [2:0] gray2bin(input [2:0] g);
        gray2bin = {g[2], g[2] ^ g[1], g[2] ^ g[1] ^ g[0]};
    endfunction
    
    // Pointer arithmetic
    wire [2:0] SP_bin = gray2bin(SP_gray);
    wire [2:0] next_SP_bin = RW ? SP_bin + 1 : SP_bin - 1;
    assign next_SP_gray = bin2gray(next_SP_bin[1:0] | {next_SP_bin[2], 2'b0});
    
    // Status logic
    wire ptr_wrap = (SP_bin[2] ^ next_SP_bin[2]);
    wire is_empty = (SP_bin == 3'b100);
    wire is_full = (SP_bin == 3'b000);
    wire op_valid = EN && ((!RW && !is_full) || (RW && !is_empty));
    
    assign EMPTY = status[3];
    assign FULL = status[2];
    assign dataOut = dataOut_reg;
    
    always @(posedge mem_clk or posedge Rst) begin
        if (Rst) begin
            SP_gray <= 3'b100; // Empty state (binary 4)
            status <= 4'b1000; // Empty flag set
            dataOut_reg <= 4'b0;
        end else begin
            // Update pointer
            SP_gray <= next_SP_gray;
            
            // Update status register
            status <= {is_empty, is_full, RW, op_valid};
            
            // Memory operations
            if (op_valid) begin
                if (!RW) begin
                    stack_mem[next_SP_bin[1:0]] <= dataIn;
                end else begin
                    dataOut_reg <= stack_mem[SP_bin[1:0]];
                end
            end
        end
    end
    
    // Clock gating for memory elements
    always @(posedge Clk) begin
        if (Rst) begin
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
    end

endmodule