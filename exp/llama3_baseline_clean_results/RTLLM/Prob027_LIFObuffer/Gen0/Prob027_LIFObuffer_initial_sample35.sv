module LIFObuffer (
    input logic [3:0] dataIn,
    input logic RW,
    input logic EN,
    input logic Rst,
    input logic Clk,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

    logic [3:0] stack_mem[0:3];
    logic [1:0] SP;

    assign EMPTY = (SP == 4);
    assign FULL = (SP == 0);

    always_ff @(posedge Clk) begin
        if (Rst) begin
            stack_mem <= '{default: 0};
            SP <= 4;
        end
        else if (EN) begin
            if (!RW && !FULL) begin // Write operation
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end
            else if (RW && !EMPTY) begin // Read operation
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 0;
                SP <= SP + 1;
            end
        end
    end

    always_comb begin
        if (!EMPTY) begin
            dataOut = stack_mem[SP];
        end
        else begin
            dataOut = 0;
        end
    end

endmodule