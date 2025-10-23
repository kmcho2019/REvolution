module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Direct mapping using case statement
reg [4:0] result; // {valid, out}
always @(*) begin
    case (code)
        8'h45: result = {1'b1, 4'd0};
        8'h16: result = {1'b1, 4'd1};
        8'h1e: result = {1'b1, 4'd2};
        8'h26: result = {1'b1, 4'd3};
        8'h25: result = {1'b1, 4'd4};
        8'h2e: result = {1'b1, 4'd5};
        8'h36: result = {1'b1, 4'd6};
        8'h3d: result = {1'b1, 4'd7};
        8'h3e: result = {1'b1, 4'd8};
        8'h46: result = {1'b1, 4'd9};
        default: result = 5'b0;
    endcase
end

assign valid = result[4];
assign out = result[3:0];

endmodule