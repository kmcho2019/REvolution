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
    reg [2:0] SP;  // 0..4; 4 means empty, 0 means full
    integer i;

    // Flags combinational from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i=0; i<4; i=i+1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0 && !FULL) begin
                // Push operation
                SP <= SP - 3'd1;
                stack_mem[SP - 3'd1] <= dataIn;
            end else if (RW == 1'b1 && !EMPTY) begin
                // Pop operation
                dataOut <= stack_mem[SP];
                SP <= SP + 3'd1;
            end
        end
    end

endmodule