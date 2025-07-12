module LIFObuffer #(
    parameter DATA_WIDTH = 4,
    parameter STACK_DEPTH = 4
) (
    input  wire                   Clk,
    input  wire                   Rst,
    input  wire                   EN,
    input  wire                   RW,        // 0 = write(push), 1 = read(pop)
    input  wire [DATA_WIDTH-1:0] dataIn,
    output wire                   EMPTY,
    output wire                   FULL,
    output reg  [DATA_WIDTH-1:0] dataOut
);

    // Stack pointer full and empty values for clarity
    localparam [2:0] SP_EMPTY = STACK_DEPTH; // 4
    localparam [2:0] SP_FULL  = 3'd0;

    reg [DATA_WIDTH-1:0] stack_mem [0:STACK_DEPTH-1];
    reg [2:0] SP;  // Stack pointer: 0 to 4

    // Push and pop enables
    wire push_en = EN && (RW == 1'b0) && (SP != SP_FULL);
    wire pop_en  = EN && (RW == 1'b1) && (SP != SP_EMPTY);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= SP_EMPTY; // Empty stack
            dataOut <= {DATA_WIDTH{1'b0}};
            for (i = 0; i < STACK_DEPTH; i = i + 1) begin
                stack_mem[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (EN) begin
            if (push_en) begin
                // Push operation: decrement SP, write dataIn at SP-1
                SP <= SP - 3'd1;
                stack_mem[SP - 3'd1] <= dataIn;
                // dataOut unchanged
            end else if (pop_en) begin
                // Pop operation: read from current SP, increment SP
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped entry
                SP <= SP + 3'd1;
            end
            // If no push/pop, maintain SP and dataOut
        end
    end

    assign EMPTY = (SP == SP_EMPTY);
    assign FULL  = (SP == SP_FULL);

endmodule