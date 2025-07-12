module TopModule (
    input           clk,
    input           load,
    input   [1:0]   ena,
    input   [99:0]  data,
    output  reg [99:0] q
);

reg [99:0] next_q;
wire update_enable;

// Determine if rotation or load will update register
assign update_enable = load || (ena == 2'b01) || (ena == 2'b10);

always @* begin
    if (load) begin
        next_q = data;
    end else begin
        case (ena)
            2'b01: next_q = {q[0], q[99:1]};   // Rotate right by 1
            2'b10: next_q = {q[98:0], q[99]};  // Rotate left by 1
            default: next_q = q;                // No rotation, hold value
        endcase
    end
end

always @(posedge clk) begin
    if (update_enable)
        q <= next_q;
    else
        q <= q; // Hold value without toggling
end

endmodule