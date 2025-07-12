module LIFObuffer(
    input  wire [3:0] dataIn,
    input  wire       RW,
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output wire [3:0] dataOut
);

reg [3:0] stack_mem [3:0];  // Stack memory array
reg [1:0] SP;               // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
        dataOut <= 4'd0;
    end else if (EN) begin
        if (!RW && (SP != 2'd0)) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && (SP != 2'd4)) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

assign EMPTY = (SP == 2'd4);
assign FULL  = (SP == 2'd0);

endmodule