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
    
    // Stack pointer (2 bits sufficient for 4 entries)
    reg [1:0] SP;
    reg [1:0] SP_next;
    
    // Operation control signals
    wire op_valid = EN && ((!RW && !FULL) || (RW && !EMPTY));
    
    // Flag generation
    assign EMPTY = (SP == 2'b00);
    assign FULL = (SP == 2'b11);
    
    // Next state logic
    always @(*) begin
        SP_next = SP;
        
        if (Rst) begin
            SP_next = 2'b00;
        end
        else if (op_valid) begin
            if (!RW) begin
                // Write operation (push)
                SP_next = SP + 1;
            end
            else begin
                // Read operation (pop)
                SP_next = SP - 1;
            end
        end
    end
    
    // Sequential logic
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'b00;
            dataOut <= 4'b0;
            // Initialize all memory locations
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (op_valid) begin
            SP <= SP_next;
            
            if (!RW) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
            end
            else begin
                // Read operation (pop)
                dataOut <= stack_mem[SP - 1];
            end
        end
    end

endmodule