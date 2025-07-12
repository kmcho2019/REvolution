module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] buffer;
    reg [1:0] write_ptr;
    
    always @(posedge clk) begin
        if (!resetn) begin
            buffer <= 4'b0;
            write_ptr <= 2'b0;
        end
        else begin
            buffer[write_ptr] <= in;
            write_ptr <= write_ptr + 1;
        end
    end
    
    // Output is the value at (write_ptr + 1) mod 4 (oldest entry)
    assign out = buffer[(write_ptr + 1) % 4];

endmodule