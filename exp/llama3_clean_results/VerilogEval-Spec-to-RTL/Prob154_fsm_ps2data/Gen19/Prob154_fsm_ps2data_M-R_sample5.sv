module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

parameter NUM_BYTES = 3;
parameter NUM_BITS = 8;

reg [1:0] byte_count;
reg [NUM_BYTES*NUM_BITS-1:0] out_bytes_reg;

assign done = (byte_count == 2);

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes_reg <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    out_bytes_reg[NUM_BYTES*NUM_BITS-1:(NUM_BYTES-1)*NUM_BITS] <= in;
                    byte_count <= 1;
                end else begin
                    byte_count <= 0;
                end
            end
            1: begin
                out_bytes_reg[(NUM_BYTES-2)*NUM_BITS:(NUM_BYTES-1)*NUM_BITS-1] <= in;
                byte_count <= 2;
            end
            2: begin
                out_bytes_reg[NUM_BITS-1:0] <= in;
                byte_count <= 0;
            end
            default: begin
                byte_count <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    out_bytes <= out_bytes_reg;
end

endmodule