module TopModule (
    input           clk,
    input           load,
    input   [1:0]   ena,
    input   [99:0]  data,
    output  reg [99:0] q
);

    localparam [1:0]
        NO_ROTATE = 2'b00,
        ROTATE_RIGHT = 2'b01,
        ROTATE_LEFT  = 2'b10,
        DISABLE_ROTATE = 2'b11;

    reg [99:0] next_q;

    always @* begin
        if (load) begin
            next_q = data;
        end else begin
            case (ena)
                ROTATE_RIGHT: next_q = {q[0], q[99:1]};      // Rotate right by one bit
                ROTATE_LEFT:  next_q = {q[98:0], q[99]};     // Rotate left by one bit
                default:      next_q = q;                     // No rotation
            endcase
        end
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule