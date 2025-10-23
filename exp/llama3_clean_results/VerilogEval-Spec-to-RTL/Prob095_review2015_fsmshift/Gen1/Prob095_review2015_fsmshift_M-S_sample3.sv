module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter;
reg reset_prev;

// sequential logic
always @(posedge clk) begin
    if (reset) begin
        counter = 4;
        reset_prev = 1'b1;
    end
    else if (counter > 0) begin
        counter = counter - 1;
        reset_prev = 1'b0;
    end
    else begin
        reset_prev = 1'b0;
    end
end

// continuous assignment
assign shift_ena = (counter > 0) && (reset || reset_prev);

endmodule