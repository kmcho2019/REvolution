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
    reg [1:0] SP, SP_next;
    reg empty_state, empty_state_next;
    
    // Operation control signals
    wire do_push = EN && !RW && !FULL;
    wire do_pop  = EN && RW && !EMPTY;
    
    // Combinational flag generation
    assign EMPTY = empty_state;
    assign FULL  = (!empty_state && (SP == 2'b11));
    
    // Next state logic
    always @(*) begin
        // Default: hold current state
        SP_next = SP;
        empty_state_next = empty_state;
        
        if (Rst) begin
            SP_next = 2'b00;
            empty_state_next = 1'b1;
        end
        else if (do_push) begin
            if (empty_state) begin
                empty_state_next = 1'b0;
            end
            else begin
                SP_next = SP + 1;
            end
        end
        else if (do_pop) begin
            if (SP == 2'b00) begin
                empty_state_next = 1'b1;
            end
            else begin
                SP_next = SP - 1;
            end
        end
    end
    
    // Sequential logic
    always @(posedge Clk) begin
        // Update state
        SP <= SP_next;
        empty_state <= empty_state_next;
        
        // Stack operations
        if (do_push) begin
            if (empty_state) begin
                stack_mem[0] <= dataIn;
            end
            else begin
                stack_mem[SP + 1] <= dataIn;
            end
        end
        else if (do_pop) begin
            dataOut <= stack_mem[SP];
        end
        
        // Reset condition
        if (Rst) begin
            dataOut <= 4'b0;
            // Only clear memory if required by spec
            // stack_mem[0] <= 4'b0;
            // stack_mem[1] <= 4'b0;
            // stack_mem[2] <= 4'b0;
            // stack_mem[3] <= 4'b0;
        end
    end

endmodule