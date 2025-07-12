module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

    reg [3:0] next_count;

    // Combinational next state logic
    always @(*) begin
        if (valid_count) begin
            if (out == 4'd11)
                next_count = 4'b0000;
            else
                next_count = out + 1'b1;
        end else begin
            next_count = out;  // Hold current count
        end
    end

    // Sequential state update with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 4'b0000;
        else
            out <= next_count;
    end

endmodule