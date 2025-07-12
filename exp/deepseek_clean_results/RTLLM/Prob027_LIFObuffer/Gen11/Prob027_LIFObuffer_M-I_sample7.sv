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

    // Stack memory (4 entries, each 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Optimized stack pointer (2 bits + empty state)
    reg [1:0] SP;
    reg empty_flag;

    // Combinational flag logic
    assign EMPTY = empty_flag;
    assign FULL = (!empty_flag) && (&SP);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set empty flag and clear only accessed location
            empty_flag <= 1'b1;
            SP <= 2'b00;
            dataOut <= 4'b0;
            // Optimized memory initialization
            for (integer i = 0; i < 4; i = i+1)
                stack_mem[i] <= 4'b0;
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
                empty_flag <= (SP == 2'b01);
            end
        end
    end

endmodule