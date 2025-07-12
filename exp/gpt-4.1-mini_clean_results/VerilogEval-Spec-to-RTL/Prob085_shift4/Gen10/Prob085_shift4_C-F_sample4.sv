module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;
wire [1:0] ctrl;

assign ctrl = {load, ena};  // ctrl[1] = load, ctrl[0] = ena

always @(*) begin
    case (ctrl)
        2'b10: next_q = data;                  // load only
        2'b01: next_q = {1'b0, q[3:1]};       // ena only (shift right)
        2'b11: next_q = data;                  // both asserted: load has priority
        default: next_q = q;                   // neither asserted
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else if (load | ena) begin
        q <= next_q;
    end
    // else hold q stable to avoid unnecessary toggling and save power
end

endmodule