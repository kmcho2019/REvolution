module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output [WIDTH-1:0] count
);

wire [WIDTH-1:0] next_count;
wire [WIDTH-1:0] current_count;

// Combinational next state logic
assign next_count = reset ? {WIDTH{1'b0}} : 
                   (up_down ? current_count + 1'b1 : current_count - 1'b1);

// Storage elements (D-flip-flops)
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : counter_ffs
        dff dff_inst (
            .clk(clk),
            .d(next_count[i]),
            .q(current_count[i])
        );
    end
endgenerate

assign count = current_count;

endmodule

// Basic D flip-flop module
module dff (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule