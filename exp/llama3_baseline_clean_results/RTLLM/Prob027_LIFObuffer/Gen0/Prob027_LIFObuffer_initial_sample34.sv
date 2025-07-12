module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;

always @ (posedge Clk) begin
    if (Rst) begin
        // Clear stack and set stack pointer to 4
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'b0;
    end else if (EN) begin
        // Check for full or empty buffer states
        if (RW == 0 && SP > 0) begin // Write operation and not full
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1 && SP < 4) begin // Read operation and not empty
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
        // Update flags
        EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
        FULL <= (SP == 0) ? 1'b1 : 1'b0;
    end
end

endmodule