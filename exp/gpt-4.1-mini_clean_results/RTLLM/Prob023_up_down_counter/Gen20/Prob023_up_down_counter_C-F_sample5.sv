module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

// Next count calculation using unary arithmetic for clear direction control
reg [15:0] next_count;

always @(*) begin
    // Determine next count based on up_down signal
    next_count = up_down ? (count + 16'd1) : (count - 16'd1);
end

// Sequential logic: synchronous reset and counting on rising edge of clk
always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        count <= next_count;
    end
end

endmodule