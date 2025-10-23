module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack pointer (SP): 0 to 4, 4 means empty, 0 means full
    reg [2:0] SP;

    // Next state signals
    reg [2:0] next_SP;
    reg [3:0] dataOut_next;
    reg       push_en, pop_en;

    integer i;

    // Combinational logic for operation enables and next SP
    always @* begin
        push_en = 0;
        pop_en  = 0;
        next_SP = SP;
        dataOut_next = dataOut;

        if (EN) begin
            if ((RW == 1'b0) && (SP != 3'd0)) begin
                // Push operation when not full
                push_en = 1'b1;
                next_SP = SP - 3'd1;
            end else if ((RW == 1'b1) && (SP != 3'd4)) begin
                // Pop operation when not empty
                pop_en = 1'b1;
                next_SP = SP + 3'd1;
            end
        end

        // On pop, dataOut_next will be updated in sequential block from stack_mem[SP]
        // On push or no operation, dataOut_next remains unchanged
    end

    // Sequential logic: registers update on rising edge of Clk
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;      // Empty stack pointer
            dataOut <= 4'd0;
            // Clear all stack memory locations
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;

            // On push, write dataIn into stack_mem[SP - 1] (new top)
            if (push_en) begin
                stack_mem[SP - 3'd1] <= dataIn;
            end

            // On pop, output data from stack_mem[SP]
            if (pop_en) begin
                dataOut <= stack_mem[SP];
            end
        end
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule