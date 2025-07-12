module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

reg [3:0] next_out;

// Combinational next state logic
always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end
    else if (valid_count) begin
        if (out == 4'b1011) begin
            next_out = 4'b0000;
        end
        else begin
            next_out = out + 1'b1;
        end
    end
    else begin
        next_out = out;
    end
end

// Sequential state update
always @(posedge clk) begin
    out <= next_out;
end

endmodule