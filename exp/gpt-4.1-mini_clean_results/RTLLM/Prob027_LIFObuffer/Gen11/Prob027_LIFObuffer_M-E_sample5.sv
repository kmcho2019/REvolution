module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,      // 0: write (push), 1: read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    reg [3:0] stack_mem [3:0];
    reg [1:0] TP;        // Top pointer index (0 to 3)
    reg [2:0] Count;     // Number of elements in stack (0 to 4)

    // Next pointers for modulo 4 arithmetic
    wire [1:0] TP_plus1 = TP + 2'd1;
    wire [1:0] TP_minus1 = TP - 2'd1;

    // On reset, clear stack, set Count=0 and TP invalid (3'b11)
    integer i;
    always @(posedge Clk) begin
        if (Rst) begin
            Count <= 3'd0;
            TP <= 2'b11;  // invalid pointer when empty
            dataOut <= 4'd0;
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push operation
                if (Count < 4) begin
                    // Increment TP modulo 4, then write dataIn
                    TP <= TP_plus1;
                    stack_mem[TP_plus1] <= dataIn;
                    Count <= Count + 1;
                    dataOut <= dataIn; // update dataOut to latest pushed
                end
                // else no push when full
            end else begin
                // Pop operation
                if (Count > 0) begin
                    dataOut <= stack_mem[TP];       // output current top
                    stack_mem[TP] <= 4'd0;          // clear popped location
                    TP <= TP_minus1;                // move pointer down modulo 4
                    Count <= Count - 1;
                    // If Count becomes 0 after pop, TP is technically invalid, but left as is until reset
                end
                // else no pop when empty
            end
        end
    end

    // Flags combinational from Count
    assign EMPTY = (Count == 3'd0);
    assign FULL  = (Count == 3'd4);

endmodule