module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst_n, // Active low reset signal
    input Clk,
    output EMPTY,
    output FULL,
    output [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [BUFFER_SIZE-1:0] SP; // Stack pointer
reg clk_en; // Clock enable signal

assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

// Clock gating
always @(posedge Clk) begin
    if (EN) begin
        clk_en <= 1'b1;
    end else begin
        clk_en <= 1'b0;
    end
end

// State machine control logic
always @(posedge Clk) begin
    if (!Rst_n) begin // Active low reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
    end else if (clk_en) begin // Clock enable signal is high
        case ({RW, FULL, EMPTY})
            3'b010: begin // RW is low, buffer is not full
                if (dataIn!= {DATA_WIDTH{1'bx}}) begin // Input data validation
                    stack_mem[SP-1] <= dataIn; // Push data onto stack
                    SP <= SP - 1; // Decrement stack pointer
                end
            end
            3'b101: begin // RW is high, buffer is not empty
                dataOut <= stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
            end
            default: begin // Do nothing for other cases
                SP <= SP;
                stack_mem[SP] <= stack_mem[SP];
            end
        endcase
    end
end

endmodule