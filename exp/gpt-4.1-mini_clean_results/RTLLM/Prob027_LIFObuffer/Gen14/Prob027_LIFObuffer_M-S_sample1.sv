module LIFObuffer(
    input  wire        Clk,
    input  wire        Rst,
    input  wire        EN,
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0]; // 4 entries, each 4 bits
    reg [2:0] SP;              // Stack pointer: 0 to 4; 4 means empty

    integer i;

    // Flags
    assign EMPTY = (SP == 4);
    assign FULL  = (SP == 0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i=0; i<4; i=i+1)
                stack_mem[i] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (SP > 0) begin
                    SP <= SP - 1;
                    stack_mem[SP - 1] <= dataIn;
                end
            end else begin
                // Read (pop)
                if (SP < 4) begin
                    dataOut <= stack_mem[SP];
                    stack_mem[SP] <= 4'd0;
                    SP <= SP + 1;
                end else begin
                    dataOut <= 4'd0;
                end
            end
        end
    end

endmodule