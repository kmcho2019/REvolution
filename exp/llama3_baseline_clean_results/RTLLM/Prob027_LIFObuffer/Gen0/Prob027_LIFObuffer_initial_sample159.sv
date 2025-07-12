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
reg [1:0] SP; // Stack Pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and set SP to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        if (!RW && SP > 0) begin // Write operation
            if (SP < 4) begin
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end
        end else if (RW && SP < 4) begin // Read operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == 4);
assign FULL = (SP == 0);
assign dataOut = (RW && SP < 4) ? stack_mem[SP] : 4'd0;

endmodule