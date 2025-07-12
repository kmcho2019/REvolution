module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

// Next state combinational logic
always @* begin
    if (!valid_count) begin
        next_out = out; // hold current count
    end else if (out == 4'd11) begin
        next_out = 4'b0000; // wrap around
    end else begin
        next_out = out + 1'b1;
    end
end

// Sequential logic: register update on clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule