module LIFObuffer (
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
    reg [2:0] SP; // stack pointer: 0..4, using 3 bits for safety

    integer i;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset: clear stack and initialize SP
                SP <= 4;
                dataOut <= 4'b0;
                EMPTY <= 1;
                FULL <= 0;
                for (i=0; i<4; i=i+1) begin
                    stack_mem[i] <= 4'b0;
                end
            end
            else begin
                // Normal operation
                if (RW == 1'b0) begin
                    // Write operation (push)
                    if (SP > 0) begin
                        SP <= SP - 1;
                        stack_mem[SP - 1] <= dataIn;
                        dataOut <= dataOut; // maintain previous output
                    end
                end
                else begin
                    // Read operation (pop)
                    if (SP < 4) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'b0;
                        SP <= SP + 1;
                    end
                end
                // Update flags
                EMPTY <= (SP == 4);
                FULL <= (SP == 0);
            end
        end
    end

endmodule