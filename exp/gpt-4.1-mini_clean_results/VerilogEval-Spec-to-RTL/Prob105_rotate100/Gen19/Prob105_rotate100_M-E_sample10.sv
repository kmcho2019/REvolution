module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [1:0]  ena,
    input  wire [99:0] data,
    output reg  [99:0] q
);

    // Combinational rotate left by 1
    wire [99:0] rotate_left  = {q[98:0], q[99]};
    // Combinational rotate right by 1
    wire [99:0] rotate_right = {q[0], q[99:1]};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b10: q <= rotate_left;
                2'b01: q <= rotate_right;
                default: q <= q;  // Hold state for 00 or 11
            endcase
        end
    end

endmodule