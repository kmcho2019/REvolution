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
reg EMPTY_reg;
reg FULL_reg;
reg [3:0] dataOut_reg;

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 2'd4;
            EMPTY_reg <= 1'b1;
            FULL_reg <= 1'b0;
        end else begin
            // Write operation
            if (~RW && ~FULL_reg) begin
                stack_mem[SP] <= dataIn;
                SP <= SP - 1;
            end
            // Read operation
            if (RW && ~EMPTY_reg) begin
                dataOut_reg <= stack_mem[SP + 1];
                stack_mem[SP + 1] <= 4'd0;
                SP <= SP + 1;
            end
        end
    end

    // Update EMPTY and FULL flags
    if (SP == 2'd4) begin
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (SP == 2'd0) begin
        EMPTY_reg <= 1'b0;
        FULL_reg <= 1'b1;
    end else begin
        EMPTY_reg <= 1'b0;
        FULL_reg <= 1'b0;
    end
end

endmodule