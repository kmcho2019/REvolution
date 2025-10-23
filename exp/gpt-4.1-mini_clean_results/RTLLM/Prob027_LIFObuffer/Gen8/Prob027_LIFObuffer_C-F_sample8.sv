module LIFObuffer (
    input  wire       Clk,
    input  wire       Rst,
    input  wire       EN,
    input  wire       RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0] dataIn,
    output reg  [3:0] dataOut,
    output wire       EMPTY,
    output wire       FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP;  // Stack pointer, counts down from 4 (empty) to 0 (full)

    // Combinational flags
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;         // Empty stack: SP=4 means empty
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP > 0) begin
                    SP <= SP - 1;              // Decrement SP first
                    stack_mem[SP - 1] <= dataIn; // Write data at new SP location
                    // dataOut unchanged on push
                end
                // else full: no operation
            end else begin
                // Read (pop)
                if (SP < 4) begin
                    dataOut <= stack_mem[SP]; // Output top of stack
                    stack_mem[SP] <= 4'd0;    // Clear popped location
                    SP <= SP + 1;             // Increment SP
                end
                // else empty: no operation, dataOut retains last value
            end
        end
    end

endmodule