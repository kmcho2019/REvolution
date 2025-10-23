module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] buffer;
reg [1:0] write_ptr;
reg [1:0] read_ptr;

always @(posedge clk) begin
    if (!resetn) begin
        buffer <= 4'b0000;
        write_ptr <= 2'b00;
        read_ptr <= 2'b00;
    end else begin
        buffer[write_ptr] <= in;
        write_ptr <= write_ptr + 1;
        if (write_ptr == 2'b11) begin
            write_ptr <= 2'b00;
        end
        out <= buffer[read_ptr];
        read_ptr <= read_ptr + 1;
        if (read_ptr == 2'b11) begin
            read_ptr <= 2'b00;
        end
    end
end

endmodule