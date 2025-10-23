module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: begin
                // Right rotation
                reg [99:0] temp_q;
                temp_q = q;
                q <= {temp_q[0], temp_q[99:1]};
            end
            2'b10: begin
                // Left rotation
                reg [99:0] temp_q;
                temp_q = q;
                q <= {temp_q[98:0], temp_q[99]};
            end
            default: begin
                // No rotation
                q <= q;
            end
        endcase
    end
end

endmodule