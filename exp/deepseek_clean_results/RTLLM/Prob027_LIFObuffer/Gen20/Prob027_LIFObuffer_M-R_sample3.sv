module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // State register: 000=empty, 001=1 entry, ..., 100=full
    reg [2:0] state;

    // Combinational outputs
    assign EMPTY = (state == 3'b000);
    assign FULL = (state == 3'b100);

    // Stack access control
    wire do_push = EN & ~RW & ~FULL;
    wire do_pop = EN & RW & ~EMPTY;
    wire [1:0] top_ptr = state[1:0] - 1'b1;

    // Push operation (write)
    always @(posedge Clk) begin
        if (Rst) begin
            state <= 3'b000;
        end else if (do_push) begin
            stack_mem[state[1:0]] <= dataIn;
            state <= state + 1'b1;
        end
    end

    // Pop operation (read)
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'b0;
        end else if (do_pop) begin
            dataOut <= stack_mem[top_ptr];
            state <= state - 1'b1;
        end
    end

endmodule