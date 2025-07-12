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

reg [3:0] stack_mem [3:0];
reg [1:0] SP;
reg [3:0] temp_dataOut;

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 4;
        end else begin
            // Check if the buffer is full or empty
            if (RW == 0 && SP != 0) begin
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end else if (RW == 1 && SP != 4) begin
                // Pop data from the stack
                temp_dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
        end
    end
end

assign dataOut = temp_dataOut;
assign EMPTY = (SP == 4) ? 1'b1 : 1'b0;
assign FULL = (SP == 0) ? 1'b1 : 1'b0;

endmodule