module LIFObuffer(
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output wire [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // 4-entry stack memory array
reg [1:0] SP;             // Stack pointer (4 for empty, 0 for full)
reg [3:0] dataOut_reg;    // Output data register

assign EMPTY = (SP == 4'd4); // Buffer is empty if SP is 4
assign FULL  = (SP == 4'd0); // Buffer is full if SP is 0

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 4'd4;
        dataOut_reg <= 4'd0;
    end else if (EN) begin
        if (RW == 1'b0 && !FULL) begin
            // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW == 1'b1 && !EMPTY) begin
            // Pop data from the stack (read operation)
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

assign dataOut = dataOut_reg;

endmodule