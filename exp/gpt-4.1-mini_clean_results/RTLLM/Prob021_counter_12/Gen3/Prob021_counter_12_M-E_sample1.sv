module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    reg [3:0] next_out;

    // Combinational logic for next state
    always @(*) begin
        if (!valid_count)
            next_out = out;                // Hold current count when counting is disabled
        else if (out == 4'd11)
            next_out = 4'd0;              // Wrap around after reaching 11
        else
            next_out = out + 1;           // Increment count
    end

    // Sequential logic to update output on clock edge with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            out <= 4'd0;
        else
            out <= next_out;
    end

endmodule