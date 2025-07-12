module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;
wire shift_enable = ena & ~load;

// Combinational pre-processing of next state
always @(*) begin
    case ({areset, load, shift_enable})
        3'b100: next_q = 4'b0;        // Reset has highest priority
        3'b010: next_q = data;        // Load has next priority
        3'b001: next_q = {1'b0, q[3:1]}; // Shift right
        default: next_q = q;          // Hold current value
    endcase
end

// Dual-edge triggered register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        q <= next_q;
    end
end

endmodule