module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3];
reg [1:0] SP;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        case (RW)
            1'b0: begin // Write operation
                if (SP!= 2'd0) begin // Buffer is not full
                    stack_mem[SP - 1] <= dataIn;
                    SP <= SP - 1'b1;
                end
            end
            1'b1: begin // Read operation
                if (SP!= 2'd4) begin // Buffer is not empty
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1'b1;
                end
            end
        endcase
    end

    // Update EMPTY and FULL flags
    if (SP == 2'd4) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (SP == 2'd0) begin
        EMPTY <= 1'b0;
        FULL <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

endmodule