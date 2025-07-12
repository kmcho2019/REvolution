module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] circular_buffer;
    reg [1:0] ptr;

    always @(posedge clk) begin
        if (!resetn) begin
            circular_buffer <= 4'b0;
            ptr <= 2'b0;
        end else begin
            circular_buffer[ptr] <= in;
            ptr <= ptr + 1'b1;  // Automatically wraps around
        end
    end

    assign out = circular_buffer[ptr];

endmodule