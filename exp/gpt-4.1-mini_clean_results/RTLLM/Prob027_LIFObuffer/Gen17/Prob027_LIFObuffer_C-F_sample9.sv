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
    reg [3:0] stack_mem [3:0];

    // Stack pointer (SP): 0..4 range, 4 = empty, 0 = full
    reg [2:0] SP;

    // Control signals for push and pop
    wire push_en = EN && (RW == 1'b0) && (SP != 3'd0); // write when not full
    wire pop_en  = EN && (RW == 1'b1) && (SP != 3'd4); // read when not empty

    // Compute addresses for push and pop
    wire [2:0] push_addr = SP - 3'd1; // push target address (new top)
    wire [2:0] pop_addr  = SP;        // pop target address (current top)

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;          // stack empty
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push_en) begin
                // Push operation: store dataIn at push_addr, decrement SP
                stack_mem[push_addr] <= dataIn;
                SP <= SP - 3'd1;
            end else if (pop_en) begin
                // Pop operation: output data from pop_addr, increment SP
                dataOut <= stack_mem[pop_addr];
                // Do not clear stack_mem to save power
                SP <= SP + 3'd1;
            end
            // No operation: hold SP and dataOut values (no toggling)
        end
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule