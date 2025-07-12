module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] current_count;
wire [3:0] next_count;

// Combinational next-state logic
assign next_count[0] = ~current_count[0];
assign next_count[1] = current_count[0] ? ~current_count[1] : current_count[1];
assign next_count[2] = (current_count[1] & current_count[0]) ? ~current_count[2] : current_count[2];
assign next_count[3] = (current_count[2] & current_count[1] & current_count[0]) ? ~current_count[3] : current_count[3];

// Sequential state storage
always @(posedge clk) begin
    if (reset) begin
        current_count <= 4'b0000;
    end else begin
        current_count <= next_count;
    end
end

assign q = current_count;

endmodule