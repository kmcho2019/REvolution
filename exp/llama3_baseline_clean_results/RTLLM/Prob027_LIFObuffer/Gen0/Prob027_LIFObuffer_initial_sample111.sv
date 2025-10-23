module LIFObuffer(
    input [3:0] dataIn,
    input RW, EN, Rst, Clk,
    output reg EMPTY, FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'd0;
            end
            SP <= 4;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
        end else begin
            if (~RW && ~FULL) begin
                // Push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
                EMPTY <= 1'b0;
                if (SP == 1) begin
                    FULL <= 1'b1;
                end else begin
                    FULL <= 1'b0;
                end
            end else if (RW && ~EMPTY) begin
                // Pop data from the stack
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 1;
                FULL <= 1'b0;
                if (SP == 4) begin
                    EMPTY <= 1'b1;
                end else begin
                    EMPTY <= 1'b0;
                end
            end
        end
    end
end

endmodule