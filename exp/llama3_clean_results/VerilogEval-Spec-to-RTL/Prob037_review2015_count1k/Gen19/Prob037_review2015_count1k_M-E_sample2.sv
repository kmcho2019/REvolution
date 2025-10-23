module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_value;

// Define the lookup table
reg [9:0] lut [0:999];

initial begin
    for (int i = 0; i < 1000; i++) begin
        if (i == 999) begin
            lut[i] = 10'd0;
        end else begin
            lut[i] = i + 1'd1;
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        counter_value <= 10'd0;
    end else begin
        counter_value <= lut[counter_value];
    end
end

assign q = counter_value;

endmodule