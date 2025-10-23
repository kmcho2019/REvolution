module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

    wire [15:0] next_count;

    // Continuous assignment for next count value
    assign next_count = up_down ? (count + 16'd1) : (count - 16'd1);

    // Sequential logic for count register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            count <= 16'd0;
        else
            count <= next_count;
    end

endmodule