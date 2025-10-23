module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic to determine next_q
    always @(*) begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                2'b01: next_q = {q[0], q[99:1]};   // Rotate right by 1
                2'b10: next_q = {q[98:0], q[99]};  // Rotate left by 1
                default: next_q = q;                // Hold current state
            endcase
        end
    end

    // Sequential logic to update q on clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule