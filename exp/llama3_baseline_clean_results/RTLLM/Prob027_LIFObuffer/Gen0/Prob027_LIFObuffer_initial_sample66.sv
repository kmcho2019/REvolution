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
reg [1:0] SP;

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 2'd4;
        end else begin
            if (!RW && (SP!= 2'd0)) begin
                // Write operation: push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end else if (RW && (SP!= 2'd4)) begin
                // Read operation: pop data from the stack
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
        end
    end
end

assign EMPTY = (SP == 2'd4);
assign FULL = (SP == 2'd0);

endmodule