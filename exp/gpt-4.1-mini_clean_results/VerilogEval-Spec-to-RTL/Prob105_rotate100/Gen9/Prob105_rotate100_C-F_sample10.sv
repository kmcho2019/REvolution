module TopModule (
    input             clk,
    input             load,
    input      [1:0]  ena,
    input      [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;
    reg        clk_en;
    integer i;

    // Combinational block to compute next_q based on current q, ena, load, and data
    always @(*) begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                2'b01: begin
                    // Rotate right by one bit: q[i] = q[(i+1) mod 100]
                    for (i = 0; i < 100; i = i + 1) begin
                        if (i == 99)
                            next_q[i] = q[0];
                        else
                            next_q[i] = q[i + 1];
                    end
                end
                2'b10: begin
                    // Rotate left by one bit: q[i] = q[(i-1 + 100) mod 100]
                    for (i = 0; i < 100; i = i + 1) begin
                        if (i == 0)
                            next_q[i] = q[99];
                        else
                            next_q[i] = q[i - 1];
                    end
                end
                default: begin
                    // No rotation: hold current q
                    next_q = q;
                end
            endcase
        end
    end

    // Clock enable is high when load is asserted or rotation is enabled (ena=01 or 10)
    always @(*) begin
        clk_en = load || (ena == 2'b01) || (ena == 2'b10);
    end

    // Register update with clock enable to prevent unnecessary toggling
    always @(posedge clk) begin
        if (clk_en) begin
            q <= next_q;
        end
    end

endmodule