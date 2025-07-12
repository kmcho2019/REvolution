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

reg [3:0] stack_mem [0:3]; // Stack memory array
integer SP = 4; // Stack pointer
reg [3:0] dataOut_reg = 4'b0; // Output data register
reg EMPTY_reg = 1'b1; // EMPTY flag register
reg FULL_reg = 1'b0; // FULL flag register

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin // Reset the buffer
            SP = 4;
            EMPTY_reg = 1'b1;
            FULL_reg = 1'b0;
            for (integer i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
        end else begin // Perform operations based on RW
            if (~RW && ~FULL_reg) begin // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
                EMPTY_reg <= 1'b0;
                if (SP == 1) begin
                    FULL_reg <= 1'b1;
                end
            end else if (RW && ~EMPTY_reg) begin // Pop data from the stack
                dataOut_reg <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
                FULL_reg <= 1'b0;
                if (SP == 4) begin
                    EMPTY_reg <= 1'b1;
                end
            end
        end
    end
end

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

endmodule