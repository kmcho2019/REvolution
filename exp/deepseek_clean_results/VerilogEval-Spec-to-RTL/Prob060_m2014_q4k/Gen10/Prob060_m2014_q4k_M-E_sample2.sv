module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] buffer;
    reg [1:0] write_ptr;
    wire [1:0] read_ptr = write_ptr + 2'd1; // Output is always next position

    always @(posedge clk) begin
        if (!resetn) begin
            buffer <= 4'b0;
            write_ptr <= 2'b0;
        end
        else begin
            buffer[write_ptr] <= in;
            write_ptr <= write_ptr + 2'd1;
        end
    end

    assign out = buffer[read_ptr];

endmodule