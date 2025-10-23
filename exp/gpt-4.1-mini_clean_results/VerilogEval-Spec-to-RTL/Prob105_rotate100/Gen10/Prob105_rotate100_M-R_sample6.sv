module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    // Combinational logic to compute next_q based on load and ena
    always @* begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                2'b01: next_q = {q[0], q[99:1]};     // rotate right
                2'b10: next_q = {q[98:0], q[99]};    // rotate left
                default: next_q = q;                  // no rotation
            endcase
        end
    end

    // Sequential logic to update q
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule