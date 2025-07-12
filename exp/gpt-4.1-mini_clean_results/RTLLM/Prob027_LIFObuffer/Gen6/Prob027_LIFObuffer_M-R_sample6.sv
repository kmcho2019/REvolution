module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;           // Current stack pointer (0 to 4)
    reg [2:0] next_SP;      // Next stack pointer value

    integer i;

    // Combinational block to determine next_SP based on current SP, RW, and flags
    always @(*) begin
        next_SP = SP; // default hold
        if (EN && !Rst) begin
            if (RW == 1'b0) begin
                // Write (push) operation: increment SP if not full
                if (SP < 3'd4)
                    next_SP = SP + 1;
            end else begin
                // Read (pop) operation: decrement SP if not empty
                if (SP > 3'd0)
                    next_SP = SP - 1;
            end
        end
    end

    // Synchronous block: update SP and stack memory
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (EN) begin
                SP <= next_SP;

                // Push operation: write dataIn at current SP (before increment)
                if (RW == 1'b0 && SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                end

                // Pop operation: update dataOut from stack_mem (after decrement)
                if (RW == 1'b1 && SP > 3'd0) begin
                    dataOut <= stack_mem[SP - 1];
                    // Optionally clear popped memory location (not necessary)
                    // stack_mem[SP - 1] <= 4'd0;
                end

                // Update flags synchronously
                EMPTY <= (next_SP == 3'd0);
                FULL <= (next_SP == 3'd4);
            end else begin
                // Hold flags and outputs if EN=0
                EMPTY <= EMPTY;
                FULL <= FULL;
                dataOut <= dataOut;
                SP <= SP;
            end
        end
    end

endmodule