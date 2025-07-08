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

    // Internal memory for stack (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (4 means empty, 0 means full)
    reg [2:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear stack and set pointer to empty
            SP <= 3'd4;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;  // Clear the popped location
                SP <= SP + 1;
            end
        end
    end

    // Combinational logic for flags
    always @(*) begin
        EMPTY = (SP == 3'd4);
        FULL = (SP == 3'd0);
    end

endmodule