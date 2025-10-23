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

    reg [3:0] stack_mem [3:0];   // 4 entries of 4-bit width
    reg [2:0] count;             // Number of stored entries: 0..4

    integer i;

    // Signals to detect valid push/pop operations
    wire push = (EN && (RW == 1'b0) && (count != 3'd4)); // can push if not full
    wire pop  = (EN && (RW == 1'b1) && (count != 3'd0)); // can pop if not empty

    always @(posedge Clk) begin
        if (Rst) begin
            count <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            if (push) begin
                // Write data at stack_mem[count], then increment count
                stack_mem[count] <= dataIn;
                count <= count + 3'd1;
            end else if (pop) begin
                // Decrement count first, then output data from stack_mem[count-1]
                count <= count - 3'd1;
                dataOut <= stack_mem[count - 3'd1];
                // No clearing of popped data for power saving
            end
            // If neither push nor pop, hold state (count and dataOut)
        end
    end

    // Flags: EMPTY if count==0, FULL if count==4
    assign EMPTY = (count == 3'd0);
    assign FULL  = (count == 3'd4);

endmodule