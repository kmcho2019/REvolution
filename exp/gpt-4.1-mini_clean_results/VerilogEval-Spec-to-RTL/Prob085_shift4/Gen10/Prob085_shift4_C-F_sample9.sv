module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire [1:0] ctrl = {load, ena};
wire [3:0] shift_val = {1'b0, q[3:1]};
reg  [3:0] next_q;

always @(*) begin
    case (ctrl)
        2'b10, 2'b11: next_q = data;        // load has priority over ena
        2'b01:        next_q = shift_val;   // ena only
        default:      next_q = q;           // hold state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else
        q <= next_q;
end

endmodule