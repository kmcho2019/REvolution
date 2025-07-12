module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

// Alternative implementation using a separate next state logic
// always @(posedge clk) begin
//     if (reset) begin
//         count <= 16'd0;
//     end else begin
//         count <= next_count;
//     end
// end

// assign next_count = (up_down)? (count + 1) : (count - 1);

endmodule