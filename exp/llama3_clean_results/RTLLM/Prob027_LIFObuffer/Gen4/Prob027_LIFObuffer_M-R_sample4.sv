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

reg [3:0] stack_mem [0:3]; // 4-entry stack memory array
reg [1:0] SP; // Stack pointer (0-3)
reg [3:0] dataOut_reg; // Register for output data

assign EMPTY = (SP == 3); // Buffer is empty when SP is 3
assign FULL = (SP == 0); // Buffer is full when SP is 0
assign dataOut = dataOut_reg; // Assign dataOut_reg to output port dataOut

// Combinational logic to determine next state of stack pointer and stack memory
wire [1:0] next_SP;
wire [3:0] next_dataOut_reg;
wire [3:0] next_stack_mem [0:3];

assign next_SP = (Rst)? 3 :
                 (EN && ~RW && ~FULL)? SP - 1 :
                 (EN && RW && ~EMPTY)? SP + 1 :
                 SP;

assign next_dataOut_reg = (Rst)? 4'b0 :
                          (EN && RW && ~EMPTY)? stack_mem[SP] :
                          dataOut_reg;

assign next_stack_mem[0] = (Rst)? 4'b0 :
                           (EN && ~RW && ~FULL && SP == 1)? dataIn :
                           stack_mem[0];

assign next_stack_mem[1] = (Rst)? 4'b0 :
                           (EN && ~RW && ~FULL && SP == 2)? dataIn :
                           stack_mem[1];

assign next_stack_mem[2] = (Rst)? 4'b0 :
                           (EN && ~RW && ~FULL && SP == 3)? dataIn :
                           stack_mem[2];

assign next_stack_mem[3] = (Rst)? 4'b0 :
                           (EN && ~RW && ~FULL && SP == 0)? dataIn :
                           stack_mem[3];

// Update stack pointer and stack memory on rising edge of clock
always @(posedge Clk) begin
    if (Rst) begin
        SP <= 3; // Initialize stack pointer to 3 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize stack memory to 0
        end
        dataOut_reg <= 4'b0; // Reset dataOut_reg
    end else if (EN) begin
        SP <= next_SP; // Update stack pointer
        dataOut_reg <= next_dataOut_reg; // Update dataOut_reg
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= next_stack_mem[i]; // Update stack memory
        end
    end
end

endmodule