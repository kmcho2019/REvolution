module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,         // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];
    // Stack pointer: points to next free position (4 means empty)
    reg [2:0] SP;

    // Flags combinational logic
    assign EMPTY = (SP == 4);
    assign FULL  = (SP == 0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 4; // empty
            dataOut <= 4'b0;
            // Clear all stack memory entries
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'b0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (SP > 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // dataOut unchanged on push
                end
                // If full, ignore push
            end else begin
                // Read (pop) operation
                if (SP < 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;  // clear popped data
                    SP <= SP + 1;
                end else begin
                    // Empty stack pop - output zero
                    dataOut <= 4'b0;
                end
            end
        end
    end

endmodule