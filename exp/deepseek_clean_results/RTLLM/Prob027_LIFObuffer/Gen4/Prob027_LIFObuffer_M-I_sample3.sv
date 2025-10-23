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
    // Stack pointer (needs to represent 0 to DEPTH)
    reg [2:0] SP;

    // Combinational flag logic
    assign EMPTY = (SP == DEPTH);
    assign FULL = (SP == 0);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset only necessary elements
            SP <= DEPTH;
            dataOut <= {WIDTH{1'b0}};
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop) - no need to clear memory
                dataOut <= stack_mem[SP];
                SP <= SP + 1;
            end
        end
    end

    // Clock gating for stack memory (power optimization)
    // Synthesis tools will implement this optimally
    always @(*) begin
        if (EN && !RW && !FULL) begin
            stack_mem[SP-1] = stack_mem[SP-1]; // Prevent latches
        end
    end

endmodule