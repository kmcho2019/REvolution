module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

wire [15:0] next_q;

assign next_q[7:0]   = byteena[0] ? d[7:0]   : q[7:0];
assign next_q[15:8]  = byteena[1] ? d[15:8]  : q[15:8];

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= next_q;
    end
end

endmodule