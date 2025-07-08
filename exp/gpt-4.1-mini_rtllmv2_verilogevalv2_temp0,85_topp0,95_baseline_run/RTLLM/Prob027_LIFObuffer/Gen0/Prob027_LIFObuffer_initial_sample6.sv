module LIFObuffer(
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0]; // 4x4-bit stack memory
    reg [2:0] SP;              // stack pointer, 3 bits to represent 0..4

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset: clear stack and set SP to 4 (empty)
                SP <= 3'd4;
                dataOut <= 4'd0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] <= 4'd0;
                end
                EMPTY <= 1'b1;
                FULL <= 1'b0;
            end else begin
                // Not reset
                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP > 0) begin
                        // Decrement SP and write dataIn at new SP
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn;
                    end
                end else begin
                    // Read operation (pop)
                    if (SP < 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'd0;
                        SP <= SP + 1;
                    end else begin
                        // Buffer empty, no pop
                        dataOut <= 4'd0;
                    end
                end

                // Update flags after operation
                EMPTY <= (SP == 3'd4);
                FULL  <= (SP == 3'd0);
            end
        end
    end

endmodule