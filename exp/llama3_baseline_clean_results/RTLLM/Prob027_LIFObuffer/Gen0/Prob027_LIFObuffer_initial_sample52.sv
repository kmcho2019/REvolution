module LIFObuffer(
    input   [3:0] dataIn,
    input         RW,
    input         EN,
    input         Rst,
    input         Clk,
    output        EMPTY,
    output        FULL,
    output  [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer

// Initialize EMPTY and FULL flags
assign EMPTY = (SP == 4)? 1'b1 : 1'b0;
assign FULL = (SP == 0)? 1'b1 : 1'b0;

always @ (posedge Clk) begin
    if (Rst) begin // Reset the buffer
        SP <= 4;
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
    end else if (EN) begin // Enable buffer operations
        if (~RW && ~FULL) begin // Write operation (push data onto the stack)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && ~EMPTY) begin // Read operation (pop data from the stack)
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

endmodule