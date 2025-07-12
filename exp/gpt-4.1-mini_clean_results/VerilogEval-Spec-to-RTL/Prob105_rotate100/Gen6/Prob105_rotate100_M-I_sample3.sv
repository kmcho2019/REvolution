module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire rotate_en = (ena == 2'b01) || (ena == 2'b10);
    wire update_en = load || rotate_en;

    reg [99:0] next_q;

    // Combinational next-state logic with bitwise muxing
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : rot_logic
            wire left_src = q[(i == 0) ? 99 : (i - 1)];
            wire right_src = q[(i == 99) ? 0 : (i + 1)];

            always @(*) begin
                if (load) begin
                    next_q[i] = data[i];
                end else if (ena == 2'b10) begin
                    // rotate left
                    next_q[i] = left_src;
                end else if (ena == 2'b01) begin
                    // rotate right
                    next_q[i] = right_src;
                end else begin
                    // hold current value
                    next_q[i] = q[i];
                end
            end
        end
    endgenerate

    // Clock gated register update to reduce power
    // Only update q when load or rotation enable signals are active
    always @(posedge clk) begin
        if (update_en) begin
            q <= next_q;
        end
    end

endmodule