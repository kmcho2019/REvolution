module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'd0;
        q <= 16'd0;
    end else begin
        case (state)
            2'd0: begin
                if (byteena[0]) begin
                    q[7:0] <= d[7:0];
                end
                if (byteena[1]) begin
                    q[15:8] <= d[15:8];
                end
                state <= 2'd1;
            end
            2'd1: begin
                if (byteena[0] && byteena[1]) begin
                    state <= 2'd0;
                end else begin
                    state <= 2'd1;
                end
            end
        endcase
    end
end

endmodule