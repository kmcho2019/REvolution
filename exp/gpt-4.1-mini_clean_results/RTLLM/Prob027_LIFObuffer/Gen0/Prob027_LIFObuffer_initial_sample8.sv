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

    // Stack memory: 4 entries, 4 bits each
    reg [3:0] stack_mem [3:0];
    // Stack pointer: points to next free position from top, range 0 to 4
    reg [2:0] SP;

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset stack pointer and clear stack memory
                SP <= 3'd4;
                dataOut <= 4'd0;
                EMPTY <= 1'b1;
                FULL <= 1'b0;
                for (i = 0; i < 4; i = i + 1)
                    stack_mem[i] <= 4'd0;
            end else begin
                // Normal operation
                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP != 0) begin
                        SP <= SP - 1'b1;
                        stack_mem[SP - 1'b1] <= dataIn;
                    end
                    // Else full, no push
                end else begin
                    // Read operation (pop)
                    if (SP != 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'd0;
                        SP <= SP + 1'b1;
                    end else begin
                        // Empty, no pop, dataOut unchanged
                    end
                end

                // Update flags after changes
                EMPTY <= (SP == 4);
                FULL  <= (SP == 0);
            end
        end
    end

endmodule