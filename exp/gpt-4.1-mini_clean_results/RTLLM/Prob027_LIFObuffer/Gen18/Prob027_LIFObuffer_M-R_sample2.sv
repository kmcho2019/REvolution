module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output wire [3:0]  dataOut
);

    // Stack memory: 4 entries of 4-bit data
    reg [3:0] stack_mem [3:0];

    // Stack pointer (SP): 0..4, 4 = empty, 0 = full
    reg [2:0] SP;

    // Push enabled if EN=1, RW=0 (write), not full
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0);

    // Pop enabled if EN=1, RW=1 (read), not empty
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4);

    integer i;

    // Synchronous update of SP
    always_ff @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;  // empty
        end else if (EN) begin
            if (push_en)
                SP <= SP - 3'd1;
            else if (pop_en)
                SP <= SP + 3'd1;
            else
                SP <= SP;
        end
    end

    // Synchronous update of stack_mem on push only
    always_ff @(posedge Clk) begin
        if (Rst) begin
            for (i = 0; i < 4; i = i +1)
                stack_mem[i] <= 4'd0;
        end else if (push_en) begin
            stack_mem[SP - 3'd1] <= dataIn;  // write new top entry
        end
        // no memory clearing on pop for power saving
    end

    // Combinational output: dataOut is top of stack when not empty, else zero
    assign dataOut = (SP != 3'd4) ? stack_mem[SP] : 4'd0;

    // Flags from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule