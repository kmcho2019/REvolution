module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic: determine next state based on load and enable
    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena == 2'b10) begin
            // Rotate left by one bit
            next_q = {q[98:0], q[99]};
        end else if (ena == 2'b01) begin
            // Rotate right by one bit
            next_q = {q[0], q[99:1]};
        end else begin
            // Hold current state (no rotation)
            next_q = q;
        end
    end

    // Sequential logic: update state at posedge clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule