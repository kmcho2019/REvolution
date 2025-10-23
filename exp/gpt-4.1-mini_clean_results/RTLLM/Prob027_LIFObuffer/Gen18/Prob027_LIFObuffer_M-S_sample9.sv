module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 0 to 4 (4 = full)

    wire push = EN && (RW == 1'b0) && (SP != 3'd4); // not full
    wire pop  = EN && (RW == 1'b1) && (SP != 3'd0); // not empty

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (push) begin
                stack_mem[SP] <= dataIn;
                SP <= SP + 3'd1;
            end else if (pop) begin
                SP <= SP - 3'd1;
                dataOut <= stack_mem[SP - 3'd1];
                // Do not clear stack_mem to reduce toggling
            end
        end
    end

    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule