module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg         EMPTY,
    output reg         FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // Stack Pointer: 0..4 (4 means empty)

    integer i;
    wire push = (EN && (RW == 1'b0) && (SP != 3'd0));
    wire pop  = (EN && (RW == 1'b1) && (SP != 3'd4));

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4; // empty state
            dataOut <= 4'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            // Initialize stack memory
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            // Push operation
            if (push) begin
                SP <= SP - 1;
                stack_mem[SP - 1] <= dataIn;
            end
            // Pop operation
            else if (pop) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 4'd0;
                SP <= SP + 1;
            end
            // No operation: maintain SP and dataOut
            
            // Update flags synchronously
            EMPTY <= (SP == 3'd4);
            FULL  <= (SP == 3'd0);
        end
    end

endmodule