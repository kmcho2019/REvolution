module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] buffer [0:BUFFER_SIZE-1]; // Circular buffer
reg [BUFFER_SIZE-1:0] head; // Head pointer
reg [BUFFER_SIZE-1:0] tail; // Tail pointer
reg [BUFFER_SIZE-1:0] count; // Grey counter

wire clk_gated;
assign clk_gated = (EN || Rst)? Clk : 1'b0;

always @(posedge clk_gated) begin
    if (Rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= {DATA_WIDTH{1'b0}};
        end
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (!RW && count < BUFFER_SIZE) begin // Push operation
            buffer[head] <= dataIn;
            head <= (head + 1) % BUFFER_SIZE;
            count <= count + 1;
            if (count == 1) begin
                EMPTY <= 1'b0;
            end
            if (count == BUFFER_SIZE) begin
                FULL <= 1'b1;
            end else begin
                FULL <= 1'b0;
            end
        end else if (RW && count > 0) begin // Pop operation
            dataOut <= buffer[tail];
            tail <= (tail + 1) % BUFFER_SIZE;
            count <= count - 1;
            if (count == 0) begin
                EMPTY <= 1'b1;
            end
            if (count == BUFFER_SIZE - 1) begin
                FULL <= 1'b0;
            end
        end
    end
end

endmodule