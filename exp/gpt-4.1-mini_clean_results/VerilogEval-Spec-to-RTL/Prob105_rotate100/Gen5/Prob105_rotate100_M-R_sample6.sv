module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] q_next;

    // Combinational logic to determine next value of q based on ena and current q
    always @(*) begin
        case (ena)
            2'b01: q_next = {q[0], q[99:1]};    // Rotate right by 1
            2'b10: q_next = {q[98:0], q[99]};   // Rotate left by 1
            default: q_next = q;                 // No change
        endcase
    end

    // Sequential update of q on rising clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;      // Load data synchronously when load is high
        end else begin
            q <= q_next;    // Otherwise, update q according to rotation logic
        end
    end

endmodule