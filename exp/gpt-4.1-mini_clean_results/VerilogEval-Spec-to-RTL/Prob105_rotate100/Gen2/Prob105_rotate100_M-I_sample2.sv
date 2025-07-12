module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] next_q;
wire update_en;

// Determine if we need to update q (load or valid rotate)
assign update_en = load | (ena == 2'b01) | (ena == 2'b10);

always @* begin
    if (load) begin
        next_q = data;
    end else begin
        case (ena)
            2'b01: next_q = {q[0], q[99:1]};  // Rotate right by one
            2'b10: next_q = {q[98:0], q[99]}; // Rotate left by one
            default: next_q = q;               // Hold value (no rotate)
        endcase
    end
end

always @(posedge clk) begin
    if (update_en) begin
        q <= next_q;
    end
end

endmodule