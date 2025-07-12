module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    reg initialized;

    always @(posedge clk) begin
        if (!initialized) begin
            q <= 4'b0000;       // synchronous reset on first clock edge
            initialized <= 1'b1;
        end else begin
            if (shift_ena) begin
                q <= {data, q[3:1]};
            end else if (count_ena) begin
                q <= q - 4'd1;
            end
            // else retain q
        end
    end

endmodule