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

    // Stack memory and stack pointer
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Number of valid elements: 0 to 4

    integer i;

    // Flags derived from SP count
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    // Sequential logic for SP and stack_mem update
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) operation
                if (!FULL) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else do nothing if full
            end else begin
                // Read (pop) operation
                if (!EMPTY) begin
                    SP <= SP - 1;
                end
                // else do nothing if empty
            end
        end
        // else EN=0: no change
    end

    // Combinational dataOut reflects top of stack (SP-1)
    assign dataOut = (!EMPTY) ? stack_mem[SP - 1] : 4'd0;

endmodule