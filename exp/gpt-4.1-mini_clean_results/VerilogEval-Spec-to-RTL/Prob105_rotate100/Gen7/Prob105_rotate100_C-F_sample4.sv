module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] q_next;

    // Combinational logic: determine next rotation state based on ena and current q
    always @(*) begin
        case (ena)
            2'b01: q_next = {q[0], q[99:1]};    // Rotate right by 1
            2'b10: q_next = {q[98:0], q[99]};   // Rotate left by 1
            default: q_next = q;                 // No change
        endcase
    end

    // Sequential logic: update q on clock edge with load priority
    always @(posedge clk) begin
        if (load) begin
            q <= data;               // Load data synchronously
        end else if (ena == 2'b01 || ena == 2'b10) begin
            q <= q_next;             // Update q only if rotation enabled
        end 
        // else retain q to minimize unnecessary toggling and power
    end

endmodule