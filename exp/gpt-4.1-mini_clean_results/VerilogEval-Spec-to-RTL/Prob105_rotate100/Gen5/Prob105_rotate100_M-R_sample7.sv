module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Next state logic for the 100-bit rotator
    reg [99:0] q_next;

    always @(*) begin
        if (load) begin
            q_next = data;  // Load data synchronously
        end else begin
            case (ena)
                2'b01: 
                    // Rotate right by one bit: q[0] moves to MSB
                    q_next = {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one bit: q[99] moves to LSB
                    q_next = {q[98:0], q[99]};
                default:
                    // No rotation, hold current value
                    q_next = q;
            endcase
        end
    end

    // Synchronous update of the register
    always @(posedge clk) begin
        q <= q_next;
    end

endmodule