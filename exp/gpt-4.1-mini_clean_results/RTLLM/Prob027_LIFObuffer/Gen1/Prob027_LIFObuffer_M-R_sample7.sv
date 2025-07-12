module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,       // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg [3:0]   dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries of 4-bit stack
    reg [2:0] SP;              // stack pointer, values 0..4, 4 means empty

    // Next state variables
    reg [2:0] next_SP;
    reg [3:0] next_stack_mem [3:0];
    reg [3:0] pop_data;        // data popped (to update dataOut)

    integer i;

    // Combinational logic to determine next SP and next stack contents
    always @* begin
        // Default: no change
        next_SP = SP;
        for (i = 0; i < 4; i = i + 1) begin
            next_stack_mem[i] = stack_mem[i];
        end
        pop_data = dataOut; // default retain output if no pop

        if (EN) begin
            if (RW == 1'b0) begin
                // Push operation (write)
                if (SP != 0) begin
                    // Decrement SP and store dataIn at new top
                    next_SP = SP - 1;
                    next_stack_mem[next_SP] = dataIn;
                end
                // else buffer full - no change
            end else begin
                // Pop operation (read)
                if (SP != 4) begin
                    // Read data at SP index, then increment SP
                    pop_data = stack_mem[SP];
                    next_stack_mem[SP] = 4'd0;  // optional clear
                    next_SP = SP + 1;
                end
                // else buffer empty - no change
            end
        end
    end

    // Sequential block: update state and outputs on clock edge
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack, pointer, flags, output
            SP <= 3'd4;
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            // Update stack memory and pointer
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= next_stack_mem[i];
            end
            SP <= next_SP;

            // Update output only on pop operation when EN and RW=1 and not empty
            if (EN && (RW == 1'b1) && (SP != 4)) begin
                dataOut <= pop_data;
            end

            // Update flags based on updated SP
            EMPTY <= (next_SP == 4);
            FULL  <= (next_SP == 0);
        end
    end

endmodule