module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Combinational next state logic
wire [3:0] next_q = shift_ena ? {q[2:0], data} :
                    count_ena ? q - 1'b1 :
                    q;

// Sequential update
always @(posedge clk) begin
    q <= next_q;
end

endmodule