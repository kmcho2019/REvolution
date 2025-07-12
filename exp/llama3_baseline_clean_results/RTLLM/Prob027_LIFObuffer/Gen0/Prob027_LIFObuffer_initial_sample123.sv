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

reg [3:0] stack_mem [3:0];
reg [1:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and set the stack pointer to 4
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        // Write operation
        if (~RW) begin
            if (SP > 4'd0) begin
                stack_mem[SP-1] <= dataIn;
                SP <= SP - 1;
            end
        end else begin
            // Read operation
            if (SP < 4'd4) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 1;
            end
        end
    end
end

always @(*) begin
    // Update the EMPTY flag
    if (SP == 4'd4) begin
        EMPTY = 1'b1;
    end else begin
        EMPTY = 1'b0;
    end
    
    // Update the FULL flag
    if (SP == 4'd0) begin
        FULL = 1'b1;
    end else begin
        FULL = 1'b0;
    end
end

endmodule