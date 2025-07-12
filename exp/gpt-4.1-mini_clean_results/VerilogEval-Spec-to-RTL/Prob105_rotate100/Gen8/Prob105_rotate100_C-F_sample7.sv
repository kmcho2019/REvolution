module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] q_next;

    // Combinational logic for next q state based on load and ena
    always @(*) begin
        if (load) begin
            q_next = data;
        end else begin
            case (ena)
                2'b01: q_next = {q[0], q[99:1]};    // Rotate right
                2'b10: q_next = {q[98:0], q[99]};   // Rotate left
                default: q_next = q;                 // Hold value
            endcase
        end
    end

    // Update q only when load or rotation is active to reduce toggling
    always @(posedge clk) begin
        if (load || (ena == 2'b01) || (ena == 2'b10))
            q <= q_next;
        // else q holds its value without toggling, saving power
    end

endmodule