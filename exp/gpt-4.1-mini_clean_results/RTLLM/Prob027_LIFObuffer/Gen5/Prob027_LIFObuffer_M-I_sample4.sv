module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write(push), 1: read(pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack pointer: counts number of items (0 to 4)

    wire write_enable;
    wire read_enable;

    assign write_enable = EN & (RW == 1'b0) & (SP < 4);
    assign read_enable  = EN & (RW == 1'b1) & (SP > 0);

    // Synchronous process for push/pop and reset
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;      // Empty stack
            dataOut <= 4'd0;
            // stack_mem contents undefined after reset (no clearing)
        end else begin
            // Write (push) operation
            if (write_enable) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            // Read (pop) operation
            else if (read_enable) begin
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
                // No clearing stack_mem to reduce toggling
            end
            // If no operation or EN=0, retain SP and dataOut
        end
    end

    // Combinational flags
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

endmodule