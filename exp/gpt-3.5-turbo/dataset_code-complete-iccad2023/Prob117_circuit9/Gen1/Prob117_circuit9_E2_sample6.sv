module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Define the state register
reg [2:0] state;

always @(posedge clk) begin
    if (a == 1 && (state != 3'd6)) begin
        state <= state + 1;
    end else if (a == 0) begin
        state <= 3'b0;
    end
end

assign q = state;

endmodule