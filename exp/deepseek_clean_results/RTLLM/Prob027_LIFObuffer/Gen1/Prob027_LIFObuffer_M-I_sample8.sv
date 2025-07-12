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

    // Stack memory (4 entries of 4 bits each)
    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
    // Stack pointer (2 bits sufficient for 0-4)
    reg [1:0] SP;

    // Combinatorial flag generation
    assign EMPTY = (SP == 2'd3); // SP=4 represented as 3 in 2 bits
    assign FULL = (SP == 2'd0);  // SP=0

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set SP to empty (3 in 2-bit representation)
            SP <= 2'd3;
            dataOut <= {WIDTH{1'b0}};
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP+1];
                SP <= SP + 1;
            end
        end
    end

    // Clock gating for stack memory (optional synthesis optimization)
    // synthesis translate_off
    always @(*) begin
        if (!EN) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                stack_mem[i] = stack_mem[i]; // Prevent unnecessary toggling
            end
        end
    end
    // synthesis translate_on

endmodule