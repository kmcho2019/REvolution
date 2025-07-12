module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer: values 0 to 4 inclusive;
    // SP == 4 means empty; SP == 0 means full
    reg [2:0] SP;
    reg [2:0] SP_next;

    // Internal signals for gating operations
    wire can_push  = EN && (RW == 1'b0) && (SP != 3'd0);
    wire can_pop   = EN && (RW == 1'b1) && (SP != 3'd4);

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

    // Write enable for stack_mem
    wire wren;
    reg [1:0] waddr;      // Write address for push
    reg [3:0] wdata;      // Write data for push

    // Read address for pop
    wire [1:0] raddr;

    // Write enable signal is true only on push
    assign wren = can_push;

    // Write address is SP-1 at the time of push (next stack position)
    always @(*) begin
        if (can_push) begin
            waddr = SP - 1;
            wdata = dataIn;
        end else begin
            waddr = 2'd0;    // default
            wdata = 4'd0;
        end
    end

    // Read address is SP at the time of pop
    assign raddr = SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            // Do NOT clear stack_mem to save power and area
        end else begin
            SP <= SP_next;
            if (can_pop) begin
                // On pop, update dataOut with top of stack
                dataOut <= stack_mem[raddr];
            end
            // else retain dataOut value (no change)
        end

        // Write data to stack_mem on push
        if (wren) begin
            stack_mem[waddr] <= wdata;
        end
    end

    // Compute next SP state
    always @(*) begin
        if (Rst) begin
            SP_next = 3'd4;
        end else if (can_push) begin
            SP_next = SP - 1;
        end else if (can_pop) begin
            SP_next = SP + 1;
        end else begin
            SP_next = SP;
        end
    end

endmodule