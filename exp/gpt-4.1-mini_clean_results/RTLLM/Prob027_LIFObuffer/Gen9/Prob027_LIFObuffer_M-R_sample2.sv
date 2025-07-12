module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,       // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    // Stack memory: 4 entries of 4 bits
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: number of elements (0 to 4)

    // Control signals derived combinationally
    wire push_enable  = EN && (RW == 1'b0) && (SP < 4);
    wire pop_enable   = EN && (RW == 1'b1) && (SP > 0);

    // Combinational flag outputs
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Sequential logic: update stack pointer
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
        end else begin
            case ({push_enable, pop_enable})
                2'b10: SP <= SP + 1; // push
                2'b01: SP <= SP - 1; // pop
                default: SP <= SP;   // no change or simultaneous push/pop (not allowed)
            endcase
        end
    end

    // Sequential logic: write to and read from stack memory and update dataOut
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else begin
            // Push operation: write dataIn to stack_mem at current SP location before SP increments
            if (push_enable) begin
                stack_mem[SP] <= dataIn;
            end

            // Pop operation: read dataOut from stack_mem at SP-1 location before SP decrements and clear that location
            if (pop_enable) begin
                dataOut <= stack_mem[SP - 1];
                stack_mem[SP - 1] <= 4'd0;
            end
            // When no pop, dataOut retains its previous value
        end
    end

endmodule