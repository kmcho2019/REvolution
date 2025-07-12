module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] current_state;
wire [3:0] next_state;

// Combinational next-state logic
assign next_state = current_state + 1;

// Sequential state storage
always @(posedge clk) begin
    if (reset) begin
        current_state <= 4'b0000;
    end
    else begin
        current_state <= next_state;
    end
end

// Output assignment
assign q = current_state;

endmodule