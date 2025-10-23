module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output wire [3:0] dataOut
);

    // Circular stack implementation
    reg [3:0] stack_mem [0:3];
    reg [2:0] SP;  // 3-bit pointer (0-7) for wrap-around
    reg [1:0] count;  // Actual entry count
    
    // Operation phases
    reg op_phase;  // 0: address phase, 1: data phase
    reg next_RW;
    
    // Predictive flags
    wire will_be_empty = (count == 1) && EN && RW;
    wire will_be_full = (count == 3) && EN && !RW;
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);
    
    // Combinational output
    assign dataOut = stack_mem[SP[1:0]];
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset clears stack and initializes pointer
            SP <= 3'b000;
            count <= 2'b00;
            op_phase <= 0;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else begin
            // Two-phase operation
            if (!op_phase) begin
                // Address phase: prepare for operation
                if (EN) begin
                    next_RW <= RW;
                    op_phase <= 1;
                end
            end
            else begin
                // Data phase: execute operation
                op_phase <= 0;
                
                if (!next_RW && !FULL) begin
                    // Push operation
                    stack_mem[SP[1:0]] <= dataIn;
                    SP <= SP + 1;
                    count <= count + 1;
                end
                else if (next_RW && !EMPTY) begin
                    // Pop operation (data already available combinationally)
                    SP <= SP - 1;
                    count <= count - 1;
                end
            end
        end
    end

endmodule