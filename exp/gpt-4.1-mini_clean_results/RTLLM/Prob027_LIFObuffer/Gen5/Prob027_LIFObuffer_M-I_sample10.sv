module LIFObuffer #(
    parameter DEPTH = 4,
    parameter WIDTH = 4
)(
    input  wire             Clk,
    input  wire             Rst,
    input  wire             EN,
    input  wire             RW,         // 0 = write(push), 1 = read(pop)
    input  wire [WIDTH-1:0] dataIn,
    output wire             EMPTY,
    output wire             FULL,
    output reg  [WIDTH-1:0] dataOut
);

    // Stack memory and pointer
    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];
    reg [2:0] SP; // 0 to DEPTH, SP = number of valid entries in stack_mem

    // Flags: EMPTY when SP==0, FULL when SP==DEPTH
    assign EMPTY = (SP == 0);
    assign FULL  = (SP == DEPTH);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
            dataOut <= {WIDTH{1'b0}};
            // Do not clear stack_mem explicitly to reduce reset latency and toggling
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP < DEPTH) begin
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                // else buffer full: no operation
            end else begin
                // Read (pop)
                if (SP > 0) begin
                    SP <= SP - 1;
                    dataOut <= stack_mem[SP - 1];
                end
                // else buffer empty: dataOut retains value
            end
        end
        // else EN=0: hold values, no change
    end

endmodule