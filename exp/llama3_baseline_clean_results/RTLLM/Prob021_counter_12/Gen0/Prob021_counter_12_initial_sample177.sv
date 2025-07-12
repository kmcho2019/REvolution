module counter_12 (
    input   logic       rst_n,
    input   logic       clk,
    input   logic       valid_count,
    output  logic [3:0] out
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000; // reset counter to 0
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000; // wrap around to 0
        end else begin
            out <= out + 1; // increment counter
        end
    end else begin
        out <= out; // counter paused, no change
    end
end

endmodule