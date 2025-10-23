module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] q_next;
    wire update_enable;

    // Determine if rotation or load should update q
    assign update_enable = load | (ena == 2'b01) | (ena == 2'b10);

    // Combinational block to compute next value of q
    always @* begin
        if (load) begin
            q_next = data;
        end else begin
            case (ena)
                2'b01: q_next = {q[0], q[99:1]};      // Rotate right by one bit
                2'b10: q_next = {q[98:0], q[99]};     // Rotate left by one bit
                default: q_next = q;                   // No change
            endcase
        end
    end

    // Sequential block to register q only when update_enable is asserted
    always @(posedge clk) begin
        if (update_enable)
            q <= q_next;
    end

endmodule