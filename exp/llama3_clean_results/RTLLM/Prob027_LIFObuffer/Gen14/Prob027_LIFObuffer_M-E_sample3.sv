module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] shift_regs [0:BUFFER_SIZE-1]; // Shift registers for stack implementation
reg [$clog2(BUFFER_SIZE):0] stack_counter; // Counter for stack pointer management

always @(posedge Clk) begin
    if (Rst) begin
        stack_counter <= 0; // Initialize stack counter to 0
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            shift_regs[i] <= {DATA_WIDTH{1'b0}}; // Initialize shift registers to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && stack_counter < BUFFER_SIZE) begin // Push operation
            // Shift data into stack
            for (int i = BUFFER_SIZE-1; i > 0; i--) begin
                shift_regs[i] <= shift_regs[i-1];
            end
            shift_regs[0] <= dataIn;
            stack_counter <= stack_counter + 1;
        end else if (RW && stack_counter > 0) begin // Pop operation
            // Shift data out of stack
            dataOut <= shift_regs[BUFFER_SIZE-1];
            for (int i = BUFFER_SIZE-1; i > 0; i--) begin
                shift_regs[i] <= shift_regs[i-1];
            end
            shift_regs[0] <= {DATA_WIDTH{1'b0}};
            stack_counter <= stack_counter - 1;
        end
    end
end

// Generate EMPTY and FULL flags based on stack counter
assign EMPTY = (stack_counter == 0);
assign FULL = (stack_counter == BUFFER_SIZE);

endmodule