module LIFObuffer(
    input       [3:0] dataIn,
    input             RW,
    input             EN,
    input             Rst,
    input             Clk,
    output reg        EMPTY,
    output reg        FULL,
    output reg [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 3 bits to cover 0 to 4

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset stack pointer and clear memory
                SP <= 3'd4;
                dataOut <= 4'd0;
                EMPTY <= 1'b1;
                FULL <= 1'b0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] <= 4'd0;
                end
            end else begin
                // Normal operation
                // Update FULL and EMPTY before operation
                EMPTY <= (SP == 3'd4);
                FULL  <= (SP == 3'd0);

                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP != 3'd0) begin
                        // Not full, push data
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn;
                        EMPTY <= 1'b0;
                        if ((SP - 1) == 3'd0)
                            FULL <= 1'b1;
                        dataOut <= dataOut; // no change
                    end
                    else begin
                        // Full, ignore write
                        dataOut <= dataOut;
                    end
                end else begin
                    // Read operation (pop)
                    if (SP != 3'd4) begin
                        // Not empty, pop data
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'd0;
                        SP <= SP + 1;
                        FULL <= 1'b0;
                        if ((SP + 1) == 3'd4)
                            EMPTY <= 1'b1;
                    end else begin
                        // Empty, ignore read
                        dataOut <= dataOut;
                    end
                end
            end
        end else begin
            // If EN is low, maintain outputs and SP
            EMPTY <= (SP == 3'd4);
            FULL  <= (SP == 3'd0);
        end
    end

endmodule