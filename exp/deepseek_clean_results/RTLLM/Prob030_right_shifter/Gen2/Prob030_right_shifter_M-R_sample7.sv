module right_shifter (
    input clk,
    input rst_n,  // active-low reset
    input d,
    output reg [7:0] q
);

wire [7:0] next_q;

// Combinational shift logic
assign next_q = {d, q[7:1]};

// Sequential element with async reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 8'b0;
    end else begin
        q <= next_q;
    end
end

endmodule