module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];    // Stack memory 4x4
    reg [2:0] SP;                 // Stack pointer 0..4 (4 = empty)

    reg [2:0] next_SP;
    reg [3:0] next_stack_mem [3:0];
    reg [3:0] dataOut_next;

    integer i;

    // Copy current stack_mem to next_stack_mem to modify selectively
    always @(*) begin
        for (i = 0; i < 4; i = i + 1)
            next_stack_mem[i] = stack_mem[i];
        next_SP = SP;
        dataOut_next = dataOut;

        if (EN) begin
            if (Rst) begin
                // Reset handled in sequential block only
            end else if (RW == 1'b0 && SP != 3'd0) begin
                // Write (push) if not full
                next_SP = SP - 3'd1;
                next_stack_mem[next_SP - 3'd1] = dataIn; // Push at SP-1
            end else if (RW == 1'b1 && SP != 3'd4) begin
                // Read (pop) if not empty
                dataOut_next = stack_mem[SP];
                next_SP = SP + 3'd1;
                // No memory clearing for power saving
            end
            // else no operation, hold states
        end
    end

    // Sequential logic: synchronous reset, update SP, stack_mem, dataOut
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;         // Empty stack
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;
            dataOut <= dataOut_next;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= next_stack_mem[i];
        end
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule