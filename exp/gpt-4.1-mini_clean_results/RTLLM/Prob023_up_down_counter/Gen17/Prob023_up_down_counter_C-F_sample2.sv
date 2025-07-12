module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

// Internal enable signal for potential future use (currently always enabled)
wire enable = 1'b1;

// Combinational logic for next count value
reg [15:0] next_count;

always @(*) begin
    next_count = up_down ? (count + 16'd1) : (count - 16'd1);
end

// Sequential logic with synchronous reset and enable
always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (enable) begin
        count <= next_count;
    end
end

endmodule