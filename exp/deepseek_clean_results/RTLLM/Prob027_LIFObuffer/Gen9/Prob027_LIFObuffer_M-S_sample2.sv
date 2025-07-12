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
    // Stack pointer (0-3) and empty state
    reg [1:0] SP;
    reg empty_flag;

    // Direct flag assignments
    assign EMPTY = empty_flag;
    assign FULL = (SP == 2'd3) && !empty_flag;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'd0;
            empty_flag <= 1'b1;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
                empty_flag <= 1'b0;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP-1];
                SP <= SP - 1;
                empty_flag <= (SP == 2'd1);
            end
        end
    end

endmodule