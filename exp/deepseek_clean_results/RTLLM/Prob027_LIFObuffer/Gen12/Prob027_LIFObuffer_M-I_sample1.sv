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
    // Combined state: {empty_flag, SP[1:0]}
    reg [2:0] state;

    // Internal signals
    wire [1:0] SP = state[1:0];
    wire empty_flag = state[2];
    wire full_flag = (!empty_flag && &SP);  // FULL when not empty and SP=3

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset to empty state
            state <= 3'b100;  // empty_flag=1, SP=00
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else begin
            // Register flags for stability
            EMPTY <= empty_flag;
            FULL <= full_flag;

            if (EN) begin
                if (!RW && !full_flag) begin
                    // Write operation (push)
                    if (empty_flag) begin
                        stack_mem[0] <= dataIn;
                        state <= 3'b000;  // empty_flag=0, SP=00
                    end
                    else begin
                        stack_mem[SP + 1] <= dataIn;
                        state <= {1'b0, SP + 1'b1};
                    end
                end
                else if (RW && !empty_flag) begin
                    // Read operation (pop)
                    dataOut <= stack_mem[SP];
                    if (SP == 2'b00) begin
                        state <= 3'b100;  // empty_flag=1, SP=00
                    end
                    else begin
                        state <= {1'b0, SP - 1'b1};
                    end
                end
            end
        end
    end

endmodule