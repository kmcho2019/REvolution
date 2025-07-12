module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Next state signals for each bit
wire next_q3, next_q2, next_q1, next_q0;

assign next_q3 = load ? data[3] : (ena ? 1'b0 : q[3]);
assign next_q2 = load ? data[2] : (ena ? q[3] : q[2]);
assign next_q1 = load ? data[1] : (ena ? q[2] : q[1]);
assign next_q0 = load ? data[0] : (ena ? q[1] : q[0]);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else begin
        q[3] <= next_q3;
        q[2] <= next_q2;
        q[1] <= next_q1;
        q[0] <= next_q0;
    end
end

endmodule