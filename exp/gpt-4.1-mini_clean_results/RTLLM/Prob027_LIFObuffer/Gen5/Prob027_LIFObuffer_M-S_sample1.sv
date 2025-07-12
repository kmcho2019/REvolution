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

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 0 (empty) to 4 (full)

    // Flags derived from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0; // Empty stack pointer
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP != 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
            end else begin
                // Read (pop)
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                    // Optional: clear popped location
                    // stack_mem[SP - 1] <= 4'd0;
                end
            end
        end
    end

endmodule