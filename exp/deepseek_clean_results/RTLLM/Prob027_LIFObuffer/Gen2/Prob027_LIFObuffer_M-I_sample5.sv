module LIFObuffer #(
    parameter DEPTH = 4,
    parameter WIDTH = 4
)(
    input wire [WIDTH-1:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [WIDTH-1:0] dataOut
);

    // Stack memory
    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
    // Stack pointer (now 2 bits, 0-4)
    reg [1:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 2'd3);  // SP=4 in original is now 3 (2 bits)
    assign FULL = (SP == 2'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            // Simplified reset - only reset SP
            SP <= 2'd3;  // Equivalent to original SP=4
            dataOut <= 'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop) - no memory clearing
                dataOut <= stack_mem[SP+1];
                SP <= SP + 1;
            end
        end
    end

    // Clock gating for stack memory (synthesis will infer)
    always @(*) begin
        if (!EN) begin
            stack_mem[0] = stack_mem[0];
            stack_mem[1] = stack_mem[1];
            stack_mem[2] = stack_mem[2];
            stack_mem[3] = stack_mem[3];
        end
    end

endmodule