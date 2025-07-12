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

    // Packed array for stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Gray-coded stack pointer (2 bits)
    reg [1:0] SP;
    wire [1:0] next_SP;

    // Gray code increment/decrement functions
    function [1:0] gray_inc;
        input [1:0] g;
        begin
            case(g)
                2'b00: gray_inc = 2'b01;
                2'b01: gray_inc = 2'b11;
                2'b11: gray_inc = 2'b10;
                2'b10: gray_inc = 2'b00;
                default: gray_inc = 2'b00;
            endcase
        end
    endfunction

    function [1:0] gray_dec;
        input [1:0] g;
        begin
            case(g)
                2'b00: gray_dec = 2'b10;
                2'b01: gray_dec = 2'b00;
                2'b11: gray_dec = 2'b01;
                2'b10: gray_dec = 2'b11;
                default: gray_dec = 2'b00;
            endcase
        end
    endfunction

    always @(posedge Clk) begin
        if (Rst) begin
            // Selective reset - only clear what's needed
            SP <= 2'b00;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            stack_mem[0] <= 4'b0; // Only clear first location
        end
        else if (EN) begin
            // Update flags first
            EMPTY <= (SP == 2'b00 && !(RW == 0 && FULL == 0));
            FULL <= (SP == 2'b10 && !(RW == 1 && EMPTY == 0));

            if (!RW && !FULL) begin
                // Unified push operation
                stack_mem[SP] <= dataIn;
                SP <= gray_inc(SP);
            end
            else if (RW && !EMPTY) begin
                // Pop operation
                dataOut <= stack_mem[gray_dec(SP)];
                SP <= gray_dec(SP);
            end
        end
    end

    // Combinational flag assignments moved inside always block
    // for better synthesis control

endmodule