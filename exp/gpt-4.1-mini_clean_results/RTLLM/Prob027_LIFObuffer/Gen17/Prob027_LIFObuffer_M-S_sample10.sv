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

    // Stack Pointer (SP):
    // Counts number of valid entries in stack: 0 = empty, 4 = full
    reg [2:0] SP; // range: 0..4

    wire push_op = EN && (RW == 1'b0) && (SP < 3'd4);
    wire pop_op  = EN && (RW == 1'b1) && (SP > 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            // Not clearing stack_mem to reduce complexity; not functionally necessary
        end else begin
            if (push_op) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop_op) begin
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule