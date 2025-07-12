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

    // State encoding: 
    // state[2] = empty flag (1=empty)
    // state[1:0] = pointer (00 to 11)
    reg [2:0] state;
    
    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Memory address decoder
    wire [1:0] mem_addr = state[1:0];
    
    // Flag assignments
    assign EMPTY = state[2];
    assign FULL = (state[1:0] == 2'b11) && !state[2];
    
    // Next state logic
    wire [2:0] next_state;
    assign next_state = 
        Rst ? 3'b100 : // Reset to empty state
        !EN ? state :  // Hold state if not enabled
        (!RW && !FULL) ? {1'b0, state[1:0] + 1'b1} : // Push operation
        (RW && !EMPTY) ? ((state[1:0] == 2'b00) ? 3'b100 : {1'b0, state[1:0] - 1'b1}) : // Pop operation
        state; // Default case
    
    // Data output logic
    always @(posedge Clk) begin
        if (EN && RW && !EMPTY) begin
            dataOut <= stack_mem[mem_addr];
        end
    end
    
    // State and memory update
    always @(posedge Clk) begin
        state <= next_state;
        
        // Push operation - write to memory
        if (EN && !RW && !FULL) begin
            stack_mem[mem_addr] <= dataIn;
        end
    end

endmodule