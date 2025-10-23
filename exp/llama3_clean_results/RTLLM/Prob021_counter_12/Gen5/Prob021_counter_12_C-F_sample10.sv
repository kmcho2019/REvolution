module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

reg [3:0] next_state;

always @ (posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        if (valid_count) begin
            if (out == 4'd11) begin
                next_state = 4'b0000;
            end else begin
                next_state = out + 1;
            end
        end else begin
            next_state = out;
        end
        out <= next_state;
    end
end

endmodule