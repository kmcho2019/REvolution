module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if(reset) begin
        q <= 1'b0; // Reset to 0 before setting to '1' as per the requirement
    end else begin
        q <= d;
    end
end

initial begin
    if(reset) begin
        q = 1'b0; // Initialize q to 0
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

wire [7:0] reset_values = 8'h34;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dffs
        DFF dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
        
        initial begin
            q[i] = reset_values[i];
        end
    end
endgenerate

endmodule