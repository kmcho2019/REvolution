module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // Combined state register: [2] = empty_flag, [1:0] = SP
    reg [2:0] state;

    // Extract components from state register
    wire empty_flag = state[2];
    wire [1:0] SP = state[1:0];

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset state (empty, SP=0)
            state <= 3'b100;
            dataOut <= 4'b0;
            FULL <= 1'b0;
            EMPTY <= 1'b1;
        end
        else if (EN) begin
            // Update flags first (registered outputs)
            FULL <= (!empty_flag && (SP == 2'b11));
            EMPTY <= empty_flag;

            if (!RW && !FULL) begin
                // Write operation (push)
                if (empty_flag) begin
                    stack_mem[0] <= dataIn;
                    state <= 3'b000; // no longer empty, SP=0
                end
                else begin
                    stack_mem[SP + 1] <= dataIn;
                    state <= {1'b0, SP + 1'b1}; // increment SP
                end
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP];
                if (SP == 2'b00) begin
                    state <= 3'b100; // set empty flag
                end
                else begin
                    state <= {1'b0, SP - 1'b1}; // decrement SP
                end
            end
        end
    end

endmodule