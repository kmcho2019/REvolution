module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [1:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 2'b10; // Reset counter to 2 when a is high
    end else if (counter < 2'b11) begin
        counter <= counter + 1; // Increment counter when a is low
    end else begin
        counter <= 2'b00; // Wrap around to 0 when counter reaches 3
    end
end

always @(posedge clk) begin
    case (counter)
        2'b00: q <= 0;
        2'b01: q <= 1;
        2'b10: q <= 4;
        2'b11: q <= 5;
        default: q <= 0;
    endcase
end

endmodule