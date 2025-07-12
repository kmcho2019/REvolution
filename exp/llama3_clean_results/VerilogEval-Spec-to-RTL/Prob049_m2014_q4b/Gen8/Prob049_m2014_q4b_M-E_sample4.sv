module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg reset_stage;

always @(posedge ar)
    reset_stage <= 1'b1;

always @(posedge clk or posedge ar)
    if (ar) begin
        reset_stage <= 1'b1;
        q <= 1'b0;
    end else if (reset_stage) begin
        reset_stage <= 1'b0;
    end else begin
        q <= d;
    end

endmodule