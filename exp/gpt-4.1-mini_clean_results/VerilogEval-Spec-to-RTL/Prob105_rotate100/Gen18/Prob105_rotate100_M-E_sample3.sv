module TopModule (
    input wire clk,
    input wire load,
    input wire [1:0] ena,
    input wire [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                2'b10: // rotate left by one
                    next_q = {q[98:0], q[99]};
                2'b01: // rotate right by one
                    next_q = {q[0], q[99:1]};
                default:
                    next_q = q;
            endcase
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule