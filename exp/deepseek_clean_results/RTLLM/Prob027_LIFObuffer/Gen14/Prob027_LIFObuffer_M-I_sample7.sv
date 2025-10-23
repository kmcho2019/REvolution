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

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Stack pointer (2 bits sufficient for 4 entries)
    reg [1:0] SP;
    
    // Operation control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop  = EN && RW && !EMPTY;
    
    // Combinational flag generation
    assign EMPTY = (SP == 2'b00);
    assign FULL  = (SP == 2'b11);
    
    // Sequential logic
    always @(posedge Clk) begin
        if (Rst) begin
            // Clear stack pointer and memory
            SP <= 2'b00;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else begin
            // Push operation
            if (do_push) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            // Pop operation
            else if (do_pop) begin
                dataOut <= stack_mem[SP-1];
                SP <= SP - 1;
            end
        end
    end

endmodule