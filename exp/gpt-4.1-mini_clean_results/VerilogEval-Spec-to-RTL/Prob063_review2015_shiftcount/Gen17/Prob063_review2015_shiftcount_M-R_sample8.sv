module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

wire [3:0] next_q;
wire ena = shift_ena | count_ena;

// Shift in MSB-first: shift right, inserting data at MSB
assign next_q = shift_ena ? {data, q[3:1]} :
                count_ena ? (q - 4'd1) :
                q;

always @(posedge clk) begin
    if (ena)
        q <= next_q;
end

endmodule