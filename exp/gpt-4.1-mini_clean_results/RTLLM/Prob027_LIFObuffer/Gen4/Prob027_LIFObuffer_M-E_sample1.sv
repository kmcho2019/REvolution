module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory and push pointer
    reg [3:0] stack_mem [3:0];
    reg [2:0] PP; // Push pointer / count of entries, 0=empty, 4=full

    // Flags derived from PP
    assign EMPTY = (PP == 3'd0);
    assign FULL  = (PP == 3'd4);

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            PP <= 3'd0;
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (!FULL) begin
                    stack_mem[PP] <= dataIn;
                    PP <= PP + 1;
                end
                // else full: no operation
            end else begin
                // Read (pop)
                if (!EMPTY) begin
                    PP <= PP - 1;
                    dataOut <= stack_mem[PP - 1];
                    // Optional: clear popped location to 0 for clarity
                    stack_mem[PP - 1] <= 4'd0;
                end
                // else empty: no operation, dataOut holds previous value
            end
        end
        // else EN=0: hold states
    end

endmodule