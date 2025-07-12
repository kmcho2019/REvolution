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

    // State encoding: [2:0] = number of valid entries (0-4)
    reg [2:0] state;
    
    // Stack memory (4 entries)
    reg [3:0] stack_mem [0:3];
    
    // Current top of stack (combinational)
    wire [3:0] current_top = (state > 0) ? stack_mem[state-1] : 4'b0;
    
    // Control signals
    wire do_push = EN && !RW && (state < 4);
    wire do_pop = EN && RW && (state > 0);
    
    // Flags
    assign EMPTY = (state == 0);
    assign FULL = (state == 4);
    
    // Stack operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset clears all memory and state
            state <= 0;
            stack_mem[0] <= 0;
            stack_mem[1] <= 0;
            stack_mem[2] <= 0;
            stack_mem[3] <= 0;
            dataOut <= 0;
        end
        else begin
            // Push operation
            if (do_push) begin
                stack_mem[state] <= dataIn;
                state <= state + 1;
            end
            // Pop operation
            else if (do_pop) begin
                dataOut <= current_top;
                state <= state - 1;
            end
        end
    end

endmodule