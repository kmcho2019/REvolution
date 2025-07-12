module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg toggle;
wire count_up_edge = up_down & toggle;
wire count_down_edge = (~up_down) | toggle;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;
        toggle <= 1'b0;
    end else if (up_down) begin
        // Rising edge: increment when toggle=0
        if (~toggle) count <= count + 1'b1;
        toggle <= ~toggle;
    end
end

always @(negedge clk or posedge reset) begin
    if (reset) begin
        // Reset handled in posedge block
    end else begin
        // Falling edge: decrement when either:
        // - counting down (up_down=0), or
        // - counting up with toggle=1
        if (count_down_edge) count <= count - 1'b1;
    end
end

endmodule