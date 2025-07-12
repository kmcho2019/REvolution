module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] buffer;
reg [6:0] head;
reg [6:0] tail;

always @(posedge clk) begin
    if (load) begin
        buffer <= data;
        head <= 0;
        tail <= 99;
    end else begin
        case (ena)
            2'b01: begin // Rotate right by one bit
                buffer <= {buffer[0], buffer[99:1]};
                head <= head - 1;
                tail <= tail - 1;
                if (head < 0) head <= 99;
                if (tail < 0) tail <= 99;
            end
            2'b10: begin // Rotate left by one bit
                buffer <= {buffer[98:0], buffer[99]};
                head <= head + 1;
                tail <= tail + 1;
                if (head > 99) head <= 0;
                if (tail > 99) tail <= 0;
            end
            default: ; // No rotation
        endcase
    end
end

assign q = buffer;

endmodule