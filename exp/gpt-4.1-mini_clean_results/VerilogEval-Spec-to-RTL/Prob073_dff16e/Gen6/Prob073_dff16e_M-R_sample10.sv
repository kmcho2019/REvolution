module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

wire [7:0] upper_byte_next;
wire [7:0] lower_byte_next;

// Select new upper byte if enabled, else hold current value
assign upper_byte_next = byteena[1] ? d[15:8] : q[15:8];
// Select new lower byte if enabled, else hold current value
assign lower_byte_next = byteena[0] ? d[7:0] : q[7:0];

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= {upper_byte_next, lower_byte_next};
end

endmodule