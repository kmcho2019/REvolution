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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (4 indicates empty, 0 indicates full)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);

    // Stack pointer update logic
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                SP <= SP + 1;
            end
        end
    end

    // Memory operation logic
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset memory (optional - could be removed if not required)
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
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                // Note: Memory clearing removed for power optimization
            end
        end
    end

endmodule