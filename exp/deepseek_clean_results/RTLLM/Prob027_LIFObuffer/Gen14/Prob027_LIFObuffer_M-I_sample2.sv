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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits to cover 0-3)
    reg [1:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset all elements
            SP <= 2'b00;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else begin
            // Update flags synchronously
            EMPTY <= (SP == 2'b00);
            FULL <= (SP == 2'b11);
            
            if (EN) begin
                if (!RW && !FULL) begin
                    // Write operation (push)
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                else if (RW && !EMPTY) begin
                    // Read operation (pop)
                    dataOut <= stack_mem[SP-1];
                    SP <= SP - 1;
                end
            end
        end
    end

endmodule