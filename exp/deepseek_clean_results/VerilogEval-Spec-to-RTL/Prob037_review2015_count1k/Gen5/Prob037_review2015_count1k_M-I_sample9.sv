module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter;
reg enable;

// Binary to gray code conversion
assign q = {counter[9], counter[9:1] ^ counter[8:0]};

// Optimized comparator for 999 (1111100111)
wire wrap_around = &{counter[9:5], counter[4:3] == 2'b00, &counter[2:1], counter[0]};

always @(posedge clk) begin
    if (reset) begin
        counter <= 10'b0;
        enable <= 1'b1;
    end else begin
        enable <= ~wrap_around;
        if (enable) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 10'b0;
        end
    end
end

endmodule