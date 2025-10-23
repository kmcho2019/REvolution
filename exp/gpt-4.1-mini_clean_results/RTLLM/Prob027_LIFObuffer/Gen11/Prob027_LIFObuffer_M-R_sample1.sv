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

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;  // Stack pointer: 4 means empty, 0 means full

    // Next-state signals
    reg [2:0] next_SP;
    reg [3:0] next_dataOut;

    // Control signals
    wire push_en  = EN && (RW == 1'b0) && (SP != 3'd0); // push if not full
    wire pop_en   = EN && (RW == 1'b1) && (SP != 3'd4); // pop if not empty

    integer i;

    // Calculate next_SP
    always @(*) begin
        if (Rst) begin
            next_SP = 3'd4;  // empty stack
        end else if (push_en) begin
            next_SP = SP - 3'd1;
        end else if (pop_en) begin
            next_SP = SP + 3'd1;
        end else begin
            next_SP = SP;
        end
    end

    // Calculate next_dataOut (updated only on pop)
    always @(*) begin
        if (pop_en) begin
            next_dataOut = stack_mem[SP];
        end else begin
            next_dataOut = dataOut;
        end
    end

    // Sequential logic: update SP, dataOut and stack_mem
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;
            dataOut <= next_dataOut;
            if (push_en) begin
                // Push data at the new top (SP - 1)
                stack_mem[SP - 3'd1] <= dataIn;
            end
            // No clearing of stack_mem on pop for power saving
        end
    end

    // Flags for empty and full
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule