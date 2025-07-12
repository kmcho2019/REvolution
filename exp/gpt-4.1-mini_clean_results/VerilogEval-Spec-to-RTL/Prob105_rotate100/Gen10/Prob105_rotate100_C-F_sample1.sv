module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    reg [99:0] next_q;
    wire       update_enable;

    assign update_enable = load | (ena == 2'b01) | (ena == 2'b10);

    always @* begin
        if (load) begin
            next_q = data;
        end else if (ena == 2'b01) begin
            // Rotate right by one bit: LSB gets MSB
            next_q = {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by one bit: MSB gets LSB
            next_q = {q[98:0], q[99]};
        end else begin
            // No change
            next_q = q;
        end
    end

    always @(posedge clk) begin
        if (update_enable)
            q <= next_q;
    end

endmodule