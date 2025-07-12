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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (3 bits to cover 0-4)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 3'b000);
    assign FULL = (SP == 3'b100);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 3'b000;
            dataOut <= 4'b0;
            // Only clear memory that might be used
            if (!EMPTY) begin
                for (integer i = 0; i < 4; i = i + 1) begin
                    if (i < SP) stack_mem[i] <= 4'b0;
                end
            end
        end
        else if (EN) begin
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

endmodule