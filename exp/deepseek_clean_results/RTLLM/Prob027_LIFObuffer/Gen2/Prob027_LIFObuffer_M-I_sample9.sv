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

    // Stack memory (parameterized depth)
    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
    // Stack pointer (one-hot encoded: 0001=empty, 1000=full)
    reg [DEPTH:0] SP;
    
    // Combinational flags
    assign EMPTY = (SP == 1);
    assign FULL = (SP[DEPTH] == 1);
    
    // Clock gating signal
    wire mem_clk = Clk & EN;

    always @(posedge mem_clk or posedge Rst) begin
        if (Rst) begin
            // Reset only necessary elements
            SP <= 1;
            dataOut <= 0;
        end
        else begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[$clog2(DEPTH+1)'(SP)] <= dataIn;
                SP <= SP << 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop) - no memory clearing
                dataOut <= stack_mem[$clog2(DEPTH+1)'(SP) - 1];
                SP <= SP >> 1;
            end
        end
    end

    // Initialize all memory locations to 0 (only in simulation)
    initial begin
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            stack_mem[i] = 0;
        end
    end

endmodule