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
    // Stack pointer (0-4 using efficient encoding)
    reg [2:0] SP;
    
    // Operation valid signal - prevents unnecessary operations
    wire op_valid = EN && ((!RW && !FULL) || (RW && !EMPTY));
    
    // Combinational flag assignments (better timing)
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: clear stack and set SP to empty
            SP <= 3'd4;
            dataOut <= 4'b0;
            // Parallel memory initialization (better for synthesis)
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (op_valid) begin
            if (!RW) begin
                // Write operation (push) - pre-decrement style
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
            else begin
                // Read operation (pop) - post-increment style
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
            end
        end
    end

endmodule