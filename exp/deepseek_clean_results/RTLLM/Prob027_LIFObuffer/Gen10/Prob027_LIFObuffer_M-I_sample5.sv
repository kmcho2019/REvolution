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
    // Stack pointer (0-3, SP=3 when empty)
    reg [1:0] SP;
    
    // Operation enable signals
    wire write_en = EN && !RW && !FULL;
    wire read_en = EN && RW && !EMPTY;

    // Flag generation logic
    always @(*) begin
        EMPTY = (SP == 2'd3);
        FULL = (SP == 2'd0);
    end

    // Write operation
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'd3;  // Empty state
        end
        else if (write_en) begin
            stack_mem[SP] <= dataIn;
            SP <= SP - 1;
        end
    end

    // Read operation
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'b0;
        end
        else if (read_en) begin
            dataOut <= stack_mem[SP+1];
            SP <= SP + 1;
        end
    end

    // Initialize memory (synthesis-time)
    integer i;
    initial begin
        for (i = 0; i < 4; i = i + 1)
            stack_mem[i] = 4'b0;
    end

endmodule