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
    // Stack pointer (0-4)
    reg [2:0] SP;
    
    // Operation valid signals
    wire write_op = EN && !RW;
    wire read_op = EN && RW;
    
    // Next stack pointer value
    wire [2:0] next_SP = Rst ? 3'd4 : 
                        (write_op && !FULL) ? SP - 1 :
                        (read_op && !EMPTY) ? SP + 1 :
                        SP;
    
    // Flags generation (combinational)
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);
    
    always @(posedge Clk) begin
        SP <= next_SP;
        
        // Memory operations
        if (Rst) begin
            // Clear memory on reset
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else begin
            if (write_op && !FULL) begin
                stack_mem[SP-1] <= dataIn;
            end
            if (read_op && !EMPTY) begin
                dataOut <= stack_mem[SP];
                // Optional: Clear popped location
                stack_mem[SP] <= 4'b0;
            end
        end
    end

endmodule