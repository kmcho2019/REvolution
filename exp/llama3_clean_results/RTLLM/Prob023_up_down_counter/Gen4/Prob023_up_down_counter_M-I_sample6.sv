module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        case (up_down)
            1'b1: count <= count + 1;
            1'b0: count <= count - 1;
            default: count <= count; // Handle undefined state, though in Verilog, default should be 1'b0 or 1'b1 for a single-bit signal
        endcase
    end
end

endmodule