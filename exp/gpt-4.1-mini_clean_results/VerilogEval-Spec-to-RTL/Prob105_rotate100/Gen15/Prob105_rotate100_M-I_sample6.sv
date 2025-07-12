module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    wire update_en = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (update_en) begin
            if (load) begin
                q <= data;
            end else if (ena == 2'b01) begin
                // rotate right by 1
                // q[0] takes q[99], q[1] takes q[0], ..., q[99] takes q[98]
                q <= {q[0], q[99:1]};
            end else if (ena == 2'b10) begin
                // rotate left by 1
                // q[99] takes q[0], q[0] takes q[1], ..., q[98] takes q[99]
                q <= {q[98:0], q[99]};
            end
        end
        // else retain q (no assignment)
    end

endmodule