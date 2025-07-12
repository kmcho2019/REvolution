module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

always @(*) begin
    case (code)
        8'h45: {valid, out} = {1'b1, 4'd0};
        8'h16: {valid, out} = {1'b1, 4'd1};
        8'h1e: {valid, out} = {1'b1, 4'd2};
        8'h26: {valid, out} = {1'b1, 4'd3};
        8'h25: {valid, out} = {1'b1, 4'd4};
        8'h2e: {valid, out} = {1'b1, 4'd5};
        8'h36: {valid, out} = {1'b1, 4'd6};
        8'h3d: {valid, out} = {1'b1, 4'd7};
        8'h3e: {valid, out} = {1'b1, 4'd8};
        8'h46: {valid, out} = {1'b1, 4'd9};
        default: {valid, out} = 5'b0;
    endcase
end

endmodule