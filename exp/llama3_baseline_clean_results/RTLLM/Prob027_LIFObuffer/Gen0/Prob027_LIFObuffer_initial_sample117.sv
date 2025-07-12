module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output EMPTY, FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [3:0];  // Stack memory
reg [1:0] SP;              // Stack pointer
reg [3:0] temp_data;       // Temporary data storage

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @ (posedge Clk)
begin
    if (Rst) begin
        // Reset: Clear stack, set stack pointer to 4, and initialize memory
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        if (!RW && !FULL) begin
            // Write operation: Push data onto the stack and decrement stack pointer
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && !EMPTY) begin
            // Read operation: Pop data from the stack, clear stack memory, and increment stack pointer
            temp_data = stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

always @ (*)
begin
    if (EMPTY) begin
        dataOut = 4'd0;
    end else begin
        dataOut = temp_data;
    end
end

endmodule