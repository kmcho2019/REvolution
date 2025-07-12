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

// Stack memory array
reg [3:0] stack_mem [0:3];
// Stack pointer (2-bit register with range 0 to 3)
reg [1:0] SP;

// State variable to track buffer state
reg [1:0] state;

// Initialize state and stack pointer on reset
always @(posedge Clk) begin
    if (Rst) begin
        SP <= 2'd3; // Initialize stack pointer to 3 (empty buffer)
        state <= 2'd0; // Initialize state to empty
    end else if (EN) begin
        case (state)
            2'd0: // Empty state
                if (!RW) begin
                    if (SP > 2'd0) begin
                        stack_mem[SP - 1] <= dataIn;
                        SP <= SP - 1;
                        if (SP == 2'd0) begin
                            state <= 2'd2; // Transition to full state
                        end else begin
                            state <= 2'd1; // Transition to neither state
                        end
                    end
                end
            2'd1: // Neither state
                if (!RW) begin
                    if (SP > 2'd0) begin
                        stack_mem[SP - 1] <= dataIn;
                        SP <= SP - 1;
                        if (SP == 2'd0) begin
                            state <= 2'd2; // Transition to full state
                        end
                    end
                end else if (RW) begin
                    if (SP < 2'd3) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'd0;
                        SP <= SP + 1;
                        if (SP == 2'd3) begin
                            state <= 2'd0; // Transition to empty state
                        end
                    end
                end
            2'd2: // Full state
                if (RW) begin
                    if (SP < 2'd3) begin
                        dataOut <= stack_mem[SP];
                        stack_mem[SP] <= 4'd0;
                        SP <= SP + 1;
                        state <= 2'd1; // Transition to neither state
                    end
                end
        endcase
    end
end

// Continuously update EMPTY and FULL flags based on stack pointer
assign EMPTY = (SP == 2'd3);
assign FULL = (SP == 2'd0);

endmodule