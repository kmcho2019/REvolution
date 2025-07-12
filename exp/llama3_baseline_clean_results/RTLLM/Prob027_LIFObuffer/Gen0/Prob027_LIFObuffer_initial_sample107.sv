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
reg EMPTY_reg;
reg FULL_reg;
reg [3:0] dataOut_reg;

assign EMPTY = EMPTY_reg;
assign FULL = FULL_reg;
assign dataOut = dataOut_reg;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (EN) begin
        // Check for push or pop operation
        if (~RW && ~FULL_reg) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            if (SP == 1) begin
                FULL_reg <= 1'b1;
            end
            EMPTY_reg <= 1'b0;
        end else if (RW && ~EMPTY_reg) begin
            // Pop data from the stack
            dataOut_reg <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
            if (SP == 4) begin
                EMPTY_reg <= 1'b1;
            end
            FULL_reg <= 1'b0;
        end
    end
end

always @(SP) begin
    // Update EMPTY and FULL flags
    if (SP == 4) begin
        EMPTY_reg <= 1'b1;
        FULL_reg <= 1'b0;
    end else if (SP == 1) begin
        EMPTY_reg <= 1'b0;
        FULL_reg <= 1'b1;
    end else begin
        EMPTY_reg <= 1'b0;
        FULL_reg <= 1'b0;
    end
end

endmodule