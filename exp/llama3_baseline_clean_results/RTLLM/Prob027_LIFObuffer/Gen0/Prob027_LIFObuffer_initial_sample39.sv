module LIFObuffer(
    input   logic       Clk,
    input   logic       Rst,
    input   logic       EN,
    input   logic       RW,
    input   logic [3:0] dataIn,
    output  logic [3:0] dataOut,
    output  logic       EMPTY,
    output  logic       FULL
);

logic [3:0] stack_mem [0:3];  // 4-entry stack memory array
logic [1:0] SP;              // Stack pointer

always_ff @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b11;  // Set stack pointer to 4 (empty buffer)
    end else if (EN) begin
        // Check if the buffer is full or empty and process data accordingly
        case (RW)
            1'b0: begin  // Write operation
                if (SP != 2'b00) begin  // Buffer is not full
                    stack_mem[SP - 1] <= dataIn;
                    SP <= SP - 1'b1;
                end
            end
            1'b1: begin  // Read operation
                if (SP != 2'b11) begin  // Buffer is not empty
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'b0;
                    SP <= SP + 1'b1;
                end
            end
        endcase
    end
end

// Update EMPTY and FULL flags based on the stack pointer status
assign EMPTY = (SP == 2'b11);
assign FULL  = (SP == 2'b00);

endmodule