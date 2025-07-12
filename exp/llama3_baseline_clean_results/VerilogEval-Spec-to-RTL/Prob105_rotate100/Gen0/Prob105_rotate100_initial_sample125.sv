module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if(load) begin
        q <= data;
    end else begin
        case(ena)
            2'b01: begin // rotate right by one bit
                reg [99:0] temp;
                temp = q;
                q[99:1] <= q[98:0];
                q[0] <= temp[99];
            end
            2'b10: begin // rotate left by one bit
                reg [99:0] temp;
                temp = q;
                q[98:0] <= q[99:1];
                q[99] <= temp[0];
            end
            default: ; // do not rotate
        endcase
    end
end

endmodule