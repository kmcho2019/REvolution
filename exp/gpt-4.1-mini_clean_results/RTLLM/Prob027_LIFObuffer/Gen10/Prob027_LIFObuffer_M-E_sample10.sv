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

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer, points to top element index (0 to 3), 4 means empty (no valid data)

    // On reset, SP=4 (empty), clear stack_mem and dataOut
    // Push: if not full, decrement SP and write dataIn to stack_mem[SP]
    // Pop: if not empty, read dataOut from stack_mem[SP], then increment SP
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // Empty stack
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP != 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                    // dataOut unchanged on push
                end
                // If full (SP == 0), no push
            end else begin
                // Read (pop)
                if (SP != 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0; // Optional: clear popped location
                    SP <= SP + 1;
                end
                // If empty (SP == 4), no pop, dataOut unchanged
            end
        end
    end

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule