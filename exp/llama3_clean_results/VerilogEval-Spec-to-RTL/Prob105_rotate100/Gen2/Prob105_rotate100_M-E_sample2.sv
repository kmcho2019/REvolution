module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

integer i;

always @(posedge clk) begin
    if (load) begin
        for (i = 0; i < 100; i++) begin
            q[i] <= data[i];
        end
    end else begin
        case (ena)
            2'b01: begin // rotate right
                for (i = 0; i < 100; i++) begin
                    if (i == 0) begin
                        q[i] <= q[99];
                    end else begin
                        q[i] <= q[i-1];
                    end
                end
            end
            2'b10: begin // rotate left
                for (i = 99; i >= 0; i--) begin
                    if (i == 99) begin
                        q[i] <= q[0];
                    end else begin
                        q[i] <= q[i+1];
                    end
                end
            end
            default: begin // no rotation
                for (i = 0; i < 100; i++) begin
                    q[i] <= q[i];
                end
            end
        endcase
    end
end

endmodule