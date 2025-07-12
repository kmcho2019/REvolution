module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire load_condition = load;
wire shift_condition = ena & ~load;
wire [3:0] next_q;

assign next_q = areset ? 4'b0 :
                load_condition ? data :
                shift_condition ? {1'b0, q[3:1]} :
                q;

always @(posedge clk or posedge areset) begin
    q <= next_q;
end

endmodule