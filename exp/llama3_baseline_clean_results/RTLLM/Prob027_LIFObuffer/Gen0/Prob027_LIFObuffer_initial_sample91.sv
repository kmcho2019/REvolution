module LIFObuffer(
    input logic [3:0] dataIn,
    input logic RW,
    input logic EN,
    input logic Rst,
    input logic Clk,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

reg [3:0] stack_mem[3:0];
integer SP = 4;

always_ff @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;
        end
        SP <= 4;
    end else if (EN) begin
        if (RW) begin // Read operation
            if (SP > 0) begin
                dataOut <= stack_mem[SP-1];
                stack_mem[SP-1] <= 0;
                SP <= SP + 1;
            end
        end else begin // Write operation
            if (SP > 0) begin
                SP <= SP - 1;
                stack_mem[SP] <= dataIn;
            end
        end
    end
end

always_comb begin
    EMPTY = (SP == 4);
    FULL = (SP == 0);
end

endmodule