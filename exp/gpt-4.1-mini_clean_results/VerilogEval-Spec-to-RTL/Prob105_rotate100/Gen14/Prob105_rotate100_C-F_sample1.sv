module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic to determine next_q based on load and ena
    always @(*) begin
        if (load) begin
            next_q = data;                 // Load data synchronously
        end else begin
            case (ena)
                2'b01: next_q = {q[0], q[99:1]};   // Rotate right by 1 bit
                2'b10: next_q = {q[98:0], q[99]};  // Rotate left by 1 bit
                default: next_q = q;                // Hold current value (no rotation)
            endcase
        end
    end

    // Sequential logic: update q only if load or rotation enabled
    always @(posedge clk) begin
        if (load || ena == 2'b01 || ena == 2'b10) begin
            q <= next_q; // Update register only if load or rotate
        end else begin
            q <= q;      // Otherwise hold current state to reduce toggling
        end
    end

endmodule