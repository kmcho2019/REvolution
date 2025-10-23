module counter_12 (
    input  wire       rst_n,        // Active low reset
    input  wire       clk,          // Clock input
    input  wire       valid_count,  // Counting enable
    output reg  [3:0] out           // 4-bit output count
);

    reg [3:0] next_out;

    // Next state combinational logic
    always @(*) begin
        if (!rst_n)
            next_out = 4'b0000;
        else if (valid_count) begin
            if (out == 4'd11)
                next_out = 4'b0000;
            else
                next_out = out + 1'b1;
        end
        else
            next_out = out;  // Hold current value if not counting
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            out <= 4'b0000;
        else
            out <= next_out;
    end

endmodule