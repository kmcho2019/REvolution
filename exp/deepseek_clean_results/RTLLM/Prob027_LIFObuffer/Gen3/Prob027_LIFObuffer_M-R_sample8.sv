module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    reg [3:0] stack_mem [0:3];  // 4-entry stack memory
    reg [1:0] SP;               // Optimized stack pointer (0-4)
    reg empty_flag, full_flag;  // Synchronous flags

    // Continuous assignments for output flags
    assign EMPTY = empty_flag;
    assign FULL = full_flag;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset initialization
            SP <= 2'd3;  // SP+1=4 indicates empty
            empty_flag <= 1'b1;
            full_flag <= 1'b0;
            dataOut <= 4'b0;
            // Memory initialization can be omitted (will be overwritten)
        end
        else if (EN) begin
            case ({RW, full_flag, empty_flag})
                3'b0_0_x: begin  // Write when not full
                    stack_mem[SP] <= dataIn;
                    SP <= SP - 1;
                    empty_flag <= 1'b0;
                    full_flag <= (SP == 0);
                end
                3'b1_x_0: begin  // Read when not empty
                    dataOut <= stack_mem[SP+1];
                    SP <= SP + 1;
                    full_flag <= 1'b0;
                    empty_flag <= (SP == 2);
                end
                default: ;  // No operation
            endcase
        end
    end

endmodule