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

reg [3:0] stack_mem [0:3];
reg [1:0] SP;  // Stack Pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b100;  // 4 in binary
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (~RW && (SP!= 2'b000)) begin
            // Write operation: push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            EMPTY <= (SP == 2'b000)? 1'b0 : 1'b1;
            FULL <= (SP == 2'b100)? 1'b0 : 1'b1;
        end else if (RW && (SP!= 2'b100)) begin
            // Read operation: pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
            EMPTY <= (SP == 2'b100)? 1'b1 : 1'b0;
            FULL <= (SP == 2'b000)? 1'b0 : 1'b1;
        end else begin
            // No operation
            EMPTY <= (SP == 2'b100)? 1'b1 : 1'b0;
            FULL <= (SP == 2'b000)? 1'b0 : 1'b1;
        end
    end
end

assign EMPTY = (SP == 2'b100)? 1'b1 : 1'b0;
assign FULL = (SP == 2'b000)? 1'b1 : 1'b0;

endmodule