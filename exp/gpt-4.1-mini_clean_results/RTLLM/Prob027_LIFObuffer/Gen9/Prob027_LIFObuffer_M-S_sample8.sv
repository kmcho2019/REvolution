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
    reg [2:0] SP;  // 0..4, 4 means empty

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Push
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
            end else begin
                // Pop
                if (SP != 3'd4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end
            end
        end
    end

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule