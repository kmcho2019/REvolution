module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;

// Combinational output assignment
assign q = counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 3'd4;  // Force to 4 when a is high
    end else begin
        // Increment with wrap-around from 6 to 0
        counter <= (counter == 3'd6) ? 3'd0 : counter + 3'd1;
    end
end

endmodule