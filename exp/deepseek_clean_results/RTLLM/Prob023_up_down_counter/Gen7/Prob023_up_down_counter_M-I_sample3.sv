module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion
wire [15:0] next_count;
assign next_count = up_down ? count + 1'b1 : count - 1'b1;

// Clock gating control
wire count_enable = ~reset & (|count[15:4] | up_down | ~(&count[3:0]));

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else if (count_enable) begin
        // Carry-select adder implementation
        if (up_down) begin
            // Increment with carry lookahead
            count[3:0] <= count[3:0] + 1'b1;
            if (&count[3:0]) count[7:4] <= count[7:4] + 1'b1;
            if (&count[7:0]) count[11:8] <= count[11:8] + 1'b1;
            if (&count[11:0]) count[15:12] <= count[15:12] + 1'b1;
        end else begin
            // Decrement with borrow lookahead
            count[3:0] <= count[3:0] - 1'b1;
            if (~|count[3:0]) count[7:4] <= count[7:4] - 1'b1;
            if (~|count[7:0]) count[11:8] <= count[11:8] - 1'b1;
            if (~|count[11:0]) count[15:12] <= count[15:12] - 1'b1;
        end
    end
end

endmodule