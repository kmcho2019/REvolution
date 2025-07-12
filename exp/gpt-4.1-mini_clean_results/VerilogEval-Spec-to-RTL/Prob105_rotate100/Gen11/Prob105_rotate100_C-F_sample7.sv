module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic for next state
    always @* begin
        if (load) begin
            // Synchronous load has highest priority
            next_q = data;
        end else begin
            case (ena)
                2'b01: 
                    // Rotate right by one bit: LSB becomes MSB
                    next_q = {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one bit: MSB becomes LSB
                    next_q = {q[98:0], q[99]};
                default: 
                    // No rotation: hold current value to avoid unnecessary toggling
                    next_q = q;
            endcase
        end
    end

    // Sequential logic to update register on rising edge of clk
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule