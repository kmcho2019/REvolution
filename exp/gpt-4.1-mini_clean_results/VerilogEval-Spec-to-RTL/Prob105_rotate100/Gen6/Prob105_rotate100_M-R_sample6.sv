module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire [99:0] rot_left;
    wire [99:0] rot_right;
    reg [99:0] next_q;

    // Compute left rotation by one bit
    assign rot_left  = {q[98:0], q[99]};
    // Compute right rotation by one bit
    assign rot_right = {q[0], q[99:1]};

    always @(*) begin
        if (load)
            next_q = data;
        else begin
            case (ena)
                2'b01: next_q = rot_right;  // rotate right
                2'b10: next_q = rot_left;   // rotate left
                default: next_q = q;        // no rotation
            endcase
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule