module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] reg_a, reg_b;
reg select;

// Initialize registers
initial begin
    reg_a = 8'b0;
    reg_b = 8'b0;
    select = 1'b0;
end

// Ping-pong shift operation
always @(posedge clk) begin
    if (select) begin
        reg_b <= {d, reg_b[7:1]};
    end else begin
        reg_a <= {d, reg_a[7:1]};
    end
    select <= ~select;
end

// Continuous output assignment
assign q = select ? reg_a : reg_b;

endmodule