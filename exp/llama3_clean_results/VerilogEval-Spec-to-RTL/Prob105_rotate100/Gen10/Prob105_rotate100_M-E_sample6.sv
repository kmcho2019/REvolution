module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Barrel shifter for right rotation
reg [99:0] right_rotated [99:0];

// Initialize barrel shifter
integer i;
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 100; i = i + 1) begin
            right_rotated[i] <= {q_reg[i], q_reg[99:i+1]};
        end

        // Select rotation based on enable signals
        case (ena)
            2'b01: q_reg <= right_rotated[1];
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]};
            default: q_reg <= q_reg;
        endcase
    end
end

assign q = q_reg;

endmodule