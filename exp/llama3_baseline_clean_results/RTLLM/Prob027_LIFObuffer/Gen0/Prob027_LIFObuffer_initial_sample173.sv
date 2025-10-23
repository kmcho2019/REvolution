module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] stack_mem [3:0];
reg [1:0] SP;
reg [3:0] temp_data;

always @(posedge Clk) begin
    if (Rst) begin
        // Clear the stack and set the stack pointer to 4
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4;
    end
    else if (EN) begin
        if (~RW && SP > 2'd0) begin
            // Push data onto the stack if it's not full
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end
        else if (RW && SP < 2'd4) begin
            // Pop data from the stack if it's not empty
            temp_data <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

always @(*) begin
    // Update the EMPTY and FULL flags
    EMPTY = (SP == 2'd4);
    FULL = (SP == 2'd0);
    
    // Output the data from the stack
    if (RW && ~EMPTY) begin
        dataOut = temp_data;
    end
    else begin
        dataOut = 4'b0;
    end
end

endmodule