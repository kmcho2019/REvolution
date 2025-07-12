module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

wire [3:0] high_bits = code[7:4];
wire [3:0] low_bits = code[3:0];

reg [3:0] out_value;
reg       valid_value;

always @(*) begin
    case (high_bits)
        4'h4: begin
            case (low_bits)
                4'h5: {out_value, valid_value} = {4'd0, 1'b1};
                4'h1: {out_value, valid_value} = {4'd1, 1'b1};
                4'hE: {out_value, valid_value} = {4'd2, 1'b1};
                default: {out_value, valid_value} = {4'd0, 1'b0};
            endcase
        end
        4'h1: begin
            case (low_bits)
                4'h6: {out_value, valid_value} = {4'd3, 1'b1};
                4'hE: {out_value, valid_value} = {4'd4, 1'b1};
                default: {out_value, valid_value} = {4'd0, 1'b0};
            endcase
        end
        4'h2: begin
            case (low_bits)
                4'hE: {out_value, valid_value} = {4'd5, 1'b1};
                4'h6: {out_value, valid_value} = {4'd6, 1'b1};
                default: {out_value, valid_value} = {4'd0, 1'b0};
            endcase
        end
        4'h3: begin
            case (low_bits)
                4'hD: {out_value, valid_value} = {4'd7, 1'b1};
                4'hE: {out_value, valid_value} = {4'd8, 1'b1};
                default: {out_value, valid_value} = {4'd0, 1'b0};
            endcase
        end
        4'h4: begin
            case (low_bits)
                4'h6: {out_value, valid_value} = {4'd9, 1'b1};
                default: {out_value, valid_value} = {4'd0, 1'b0};
            endcase
        end
        default: {out_value, valid_value} = {4'd0, 1'b0};
    endcase
end

assign out = valid_value ? out_value : 4'd0;
assign valid = valid_value;

endmodule