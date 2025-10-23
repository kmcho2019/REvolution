module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] buffer;
reg [6:0]  read_idx;
reg [6:0]  write_idx;

always @(posedge clk) begin
    if (load) begin
        buffer <= data;
        write_idx <= 0;
    end else begin
        case (ena)
            2'b01: begin
                // Rotate right by one bit
                read_idx <= (read_idx - 1) % 100;
            end
            2'b10: begin
                // Rotate left by one bit
                read_idx <= (read_idx + 1) % 100;
            end
            default: begin
                // Do not rotate
            end
        endcase
    end
end

always @(*) begin
    q = buffer;
end

endmodule