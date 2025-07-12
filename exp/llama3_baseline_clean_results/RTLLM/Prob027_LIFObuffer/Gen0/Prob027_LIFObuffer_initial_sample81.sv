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

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 2'd4;
        end else begin
            // Check if the buffer is empty
            if (SP == 2'd4) begin
                EMPTY <= 1'b1;
                FULL <= 1'b0;
                dataOut <= 4'd0;
            end else if (SP == 2'd0) begin
                // Check if the buffer is full
                EMPTY <= 1'b0;
                FULL <= 1'b1;
                dataOut <= 4'd0;
            end else begin
                EMPTY <= 1'b0;
                FULL <= 1'b0;
                dataOut <= 4'd0;
            end

            // Perform push or pop operation
            if (~RW && SP > 2'd0 && ~FULL) begin
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end else if (RW && SP < 2'd4 && ~EMPTY) begin
                // Pop data from the stack
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 1;
            end
        end
    end
end

assign EMPTY = (SP == 2'd4) ? 1'b1 : 1'b0;
assign FULL = (SP == 2'd0) ? 1'b1 : 1'b0;

endmodule