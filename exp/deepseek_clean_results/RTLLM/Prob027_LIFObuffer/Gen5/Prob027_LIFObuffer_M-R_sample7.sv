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
    
    // Stack pointer states
    localparam SP_EMPTY = 3'd4;
    localparam SP_FULL  = 3'd0;
    
    // Current and next stack pointer
    reg [2:0] SP, SP_next;
    
    // Operation control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop  = EN && RW && !EMPTY;
    
    // Combinational flag generation
    assign EMPTY = (SP == SP_EMPTY);
    assign FULL  = (SP == SP_FULL);
    
    // Next state logic
    always @(*) begin
        SP_next = SP;  // Default: hold current state
        
        if (Rst) begin
            SP_next = SP_EMPTY;
        end
        else if (do_push) begin
            SP_next = SP - 1;
        end
        else if (do_pop) begin
            SP_next = SP + 1;
        end
    end
    
    // Sequential logic
    always @(posedge Clk) begin
        // Stack pointer update
        SP <= SP_next;
        
        // Stack operations
        if (do_push) begin
            stack_mem[SP-1] <= dataIn;
        end
        else if (do_pop) begin
            dataOut <= stack_mem[SP];
        end
        
        // Reset condition
        if (Rst) begin
            dataOut <= 4'b0;
        end
    end

endmodule