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
    reg [2:0] SP; // 0 to 4 entries

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin  // Push
                if (SP < 4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
            end else begin         // Pop
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
            end
        end
    end

    assign EMPTY = (SP == 0);
    assign FULL  = (SP == 4);

endmodule