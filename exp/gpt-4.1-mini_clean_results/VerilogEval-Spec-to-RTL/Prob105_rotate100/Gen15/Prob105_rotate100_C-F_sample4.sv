module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    reg [99:0] next_value;

    always @* begin
        if (load) begin
            next_value = data;
        end else if (ena == 2'b10) begin
            // Rotate left by 1 bit: MSB wraps to LSB
            next_value = {q[98:0], q[99]};
        end else if (ena == 2'b01) begin
            // Rotate right by 1 bit: LSB wraps to MSB
            next_value = {q[0], q[99:1]};
        end else begin
            // Hold current value
            next_value = q;
        end
    end

    always @(posedge clk) begin
        q <= next_value;
    end

endmodule