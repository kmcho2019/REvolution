module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        case ({load, ena})
            3'b1xx: q <= data;                     // load data synchronously, ignore ena
            3'b010: q <= {q[98:0], q[99]};         // rotate left by 1
            3'b001: q <= {q[0], q[99:1]};          // rotate right by 1
            default: q <= q;                        // hold current value
        endcase
    end

endmodule