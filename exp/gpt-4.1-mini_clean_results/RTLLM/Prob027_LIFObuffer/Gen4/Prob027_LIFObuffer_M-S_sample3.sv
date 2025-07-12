module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack Pointer: 0..4, 4 = empty

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            // stack_mem not cleared for simplicity
        end else if (EN) begin
            if (RW == 1'b0) begin // push
                if (SP != 3'd0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
                // else full: no action
            end else begin // pop
                if (SP != 3'd4) begin
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                    // memory not cleared on pop
                end
                // else empty: no action
            end
        end
        // else EN=0: hold state
    end

endmodule