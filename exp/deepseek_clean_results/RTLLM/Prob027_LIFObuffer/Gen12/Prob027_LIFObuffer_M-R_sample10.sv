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
    // Stack pointer (2 bits)
    reg [1:0] SP;
    
    // Operation validation and control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop = EN && RW && !EMPTY;
    
    // Combinational flag assignments
    assign EMPTY = (SP == 2'b00);
    assign FULL = (SP == 2'b11);
    
    // Next stack pointer calculation
    wire [1:0] next_SP = 
        Rst ? 2'b00 : 
        do_push ? SP + 1 : 
        do_pop ? SP - 1 : 
        SP;
    
    // Memory write address calculation
    wire [1:0] write_addr = SP;  // Write to current SP for push
    
    // Control logic: Stack pointer update
    always @(posedge Clk) begin
        SP <= next_SP;
    end
    
    // Data path: Memory and output
    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize all memory locations
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else begin
            if (do_push) begin
                stack_mem[write_addr] <= dataIn;
            end
            if (do_pop) begin
                dataOut <= stack_mem[SP-1];
            end
        end
    end

endmodule