module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

// Efficient next state computation using parallel logic
assign next_count[0] = ~count[0];
assign next_count[1] = count[0] ? ~count[1] : count[1];
assign next_count[2] = (&count[1:0]) ? ~count[2] : count[2];
assign next_count[3] = (&count[2:0]) ? ~count[3] : count[3];

// Sequential update with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0000;
    end
    else begin
        count <= next_count;
    end
end

assign q = count;

endmodule