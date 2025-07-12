module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    wire update_en = load | (ena == 2'b10) | (ena == 2'b01);

    wire ena_left  = (ena == 2'b10);
    wire ena_right = (ena == 2'b01);

    reg [99:0] next_q;

    integer i;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena_left) begin
            // Rotate left by 1: MSB = LSB, bits shift up by 1
            next_q[98:0] = q[99:1];
            next_q[99]    = q[0];
        end else if (ena_right) begin
            // Rotate right by 1: LSB = MSB, bits shift down by 1
            next_q[99:1] = q[98:0];
            next_q[0]    = q[99];
        end else begin
            next_q = q;
        end
    end

    always @(posedge clk) begin
        if (update_en)
            q <= next_q;
    end

endmodule