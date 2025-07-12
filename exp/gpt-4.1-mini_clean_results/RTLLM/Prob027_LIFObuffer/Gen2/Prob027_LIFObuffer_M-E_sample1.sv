module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,    // 0: write(push), 1: read(pop)
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);
    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // points to next free position: 0(empty) to 4(full)

    integer i;

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd0;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push) if not full
                if (SP < 3'd4) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1'b1;
                end
            end else begin
                // Read (pop) if not empty
                if (SP > 3'd0) begin
                    SP <= SP - 1'b1;
                    dataOut <= stack_mem[SP - 1];
                    stack_mem[SP - 1] <= 4'd0;
                end
            end
        end
    end

endmodule