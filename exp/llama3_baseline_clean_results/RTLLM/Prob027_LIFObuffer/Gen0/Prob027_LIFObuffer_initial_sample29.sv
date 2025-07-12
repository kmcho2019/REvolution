module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // stack memory
reg [1:0] SP; // stack pointer
reg [3:0] dataOut_reg; // data out register

// Initialize EMPTY and FULL flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// Sequential logic
always @(posedge Clk) begin
    if (Rst) begin
        // Reset stack memory and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Write operation: push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && ~EMPTY) begin
            // Read operation: pop data from the stack
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'b0; // clear the popped memory location
            SP <= SP + 1;
        end
    end
end

// Combinational logic
assign dataOut = dataOut_reg;

endmodule