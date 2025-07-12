module LIFObuffer(
    input logic [3:0] dataIn,
    input logic RW,
    input logic EN,
    input logic Rst,
    input logic Clk,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

    logic [3:0] stack_mem [0:3];
    logic [1:0] SP;

    always_ff @(posedge Clk) begin
        if (Rst) begin
            // Reset stack, pointer, and flags
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else if (EN) begin
            // Write operation (push data onto the stack)
            if (!RW && !FULL) begin
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end
            // Read operation (pop data from the stack)
            else if (RW && !EMPTY) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'b0;
                SP <= SP + 1;
            end
        end
    end

    always_comb begin
        // Update flags based on stack pointer
        EMPTY = (SP == 4);
        FULL = (SP == 0);
        // Update dataOut when buffer is not empty
        if (!EMPTY) begin
            dataOut = stack_mem[SP];
        end else begin
            dataOut = 4'b0;
        end
    end

endmodule