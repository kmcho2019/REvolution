module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack pointer: number of elements in stack, 0 to 4

    // Internal signals for push and pop enables
    wire push_en = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_en  = EN && (RW == 1'b1) && (SP > 3'd0);

    reg [3:0] pop_data;  // Temporary register to hold popped data before SP update

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
            pop_data <= 4'd0;
        end else begin
            if (push_en) begin
                // Push dataIn onto stack_mem[SP], increment SP
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
                // dataOut holds previous value during push
            end else if (pop_en) begin
                // First read the data at SP-1 into pop_data
                pop_data <= stack_mem[SP - 1];
                SP <= SP - 3'd1;
            end
            // Update dataOut after SP update to avoid timing hazard
            // (Non-blocking ensures pop_data updated first)
            if (pop_en)
                dataOut <= pop_data;
            // Else dataOut holds value from last pop
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule