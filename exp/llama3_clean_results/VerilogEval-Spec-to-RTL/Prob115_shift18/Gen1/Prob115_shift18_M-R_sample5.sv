module TopModule(
    input               clk,
    input               load,
    input               ena,
    input       [1:0]   amount,
    input       [63:0]  data,
    output reg  [63:0]  q
);

wire [63:0] shifted_q;

assign shifted_q = (amount == 2'b00) ? {q[62:0], 1'b0} :
                  (amount == 2'b01) ? {q[55:0], 8'b0} :
                  (amount == 2'b10) ? {q[63], q[63:1]} :
                  (amount == 2'b11) ? {16{q[63]}, q[63:8]} :
                  q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= shifted_q;
    end
end

endmodule