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
    reg [2:0] SP; // Stack pointer: 0..3 valid indices, 3'b111 (-1) means empty

    integer i;

    // Define a localparam for empty SP
    localparam SP_EMPTY = 3'b111;

    always @(posedge Clk) begin
        if (EN) begin
            if (Rst) begin
                // Reset stack
                SP <= SP_EMPTY;
                dataOut <= 4'b0;
                EMPTY <= 1'b1;
                FULL <= 1'b0;
                for (i = 0; i < 4; i = i + 1) begin
                    stack_mem[i] <= 4'b0;
                end
            end else begin
                // Default outputs keep previous value unless changed below
                // Push operation: RW=0 and not full
                if ((RW == 1'b0) && (FULL == 1'b0)) begin
                    SP <= SP + 1;
                    stack_mem[SP + 1] <= dataIn;
                    dataOut <= dataOut; // keep previous output
                end
                // Pop operation: RW=1 and not empty
                else if ((RW == 1'b1) && (EMPTY == 1'b0)) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP - 1;
                end else begin
                    dataOut <= dataOut; // no operation, hold dataOut
                end

                // Update flags based on new SP value (consider non-blocking assignment delay)
                // Use temporary variable to compute next SP for flags
                // SP is not updated immediately, so we calculate next_SP:
                reg [2:0] next_SP;
                next_SP = SP;

                if ((RW == 1'b0) && (FULL == 1'b0)) begin
                    next_SP = SP + 1;
                end else if ((RW == 1'b1) && (EMPTY == 1'b0)) begin
                    next_SP = SP - 1;
                end

                EMPTY <= (next_SP == SP_EMPTY);
                FULL <= (next_SP == 3'd3);
            end
        end
    end

endmodule