module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;
    wire ce;  // Clock enable for q register update

    // Clock enable is high only if load is asserted or a valid rotate (ena=01 or 10)
    assign ce = load | (ena == 2'b01) | (ena == 2'b10);

    // Combinational logic to determine next_q
    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena == 2'b01) begin
            // Rotate right by 1
            next_q = {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by 1
            next_q = {q[98:0], q[99]};
        end else begin
            next_q = q; // Hold current state
        end
    end

    // Sequential logic with clock enable to update q on clock edge
    always @(posedge clk) begin
        if (ce) begin
            q <= next_q;
        end
        // else retain previous q, no toggling
    end

endmodule