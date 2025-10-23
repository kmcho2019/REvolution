module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;
    wire ce; // clock enable for q update

    // Clock enable active when load or exactly one rotation direction is selected
    assign ce = load | (ena == 2'b01) | (ena == 2'b10);

    // Combinational logic to determine next_q
    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena == 2'b01) begin
            // Rotate right by 1: LSB wraps to MSB
            next_q = {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by 1: MSB wraps to LSB
            next_q = {q[98:0], q[99]};
        end else begin
            next_q = q;
        end
    end

    // Sequential update of q with clock enable
    always @(posedge clk) begin
        if (ce)
            q <= next_q;
    end

endmodule