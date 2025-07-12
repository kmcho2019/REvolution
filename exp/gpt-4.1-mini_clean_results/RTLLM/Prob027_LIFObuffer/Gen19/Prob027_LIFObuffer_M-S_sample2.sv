module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write(push), 1 = read(pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    reg [3:0] stack_mem [3:0];
    reg [2:0] SP; // 3-bit pointer: 4=empty, 0=full

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 3'd4;
            dataOut <= 4'd0;
            stack_mem[0] <= 4'd0;
            stack_mem[1] <= 4'd0;
            stack_mem[2] <= 4'd0;
            stack_mem[3] <= 4'd0;
        end else if (EN) begin
            if (RW == 1'b0) begin // write (push)
                if (SP != 3'd0) begin
                    SP <= SP - 3'd1;
                    stack_mem[SP - 3'd1] <= dataIn;
                end
            end else begin // read (pop)
                if (SP != 3'd4) begin
                    dataOut <= stack_mem[SP];
                    SP <= SP + 3'd1;
                end
            end
        end
    end

    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule