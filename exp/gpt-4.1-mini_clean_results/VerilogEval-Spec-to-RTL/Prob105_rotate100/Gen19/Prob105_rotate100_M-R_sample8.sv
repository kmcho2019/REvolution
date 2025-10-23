module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic to calculate next state
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
            next_q = q;  // Hold current state
        end
    end

    // Sequential logic to update state on clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule