module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire [3:0] next_out;

// Next count logic (combinational)
assign next_out = (!valid_count)         ? out :
                  (out == 4'd11)         ? 4'd0 :
                                          out + 4'd1;

// Sequential register update with async reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'd0;
    else
        out <= next_out;
end

endmodule