module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Named parameters for keyboard scancodes
localparam CODE_0 = 8'h45;
localparam CODE_1 = 8'h16;
localparam CODE_2 = 8'h1e;
localparam CODE_3 = 8'h26;
localparam CODE_4 = 8'h25;
localparam CODE_5 = 8'h2e;
localparam CODE_6 = 8'h36;
localparam CODE_7 = 8'h3d;
localparam CODE_8 = 8'h3e;
localparam CODE_9 = 8'h46;

always @(*) begin
    // Default outputs (power optimization)
    out = 0;
    valid = 0;
    
    // Parallel case evaluation
    case (code)
        CODE_0: {out, valid} = {4'd0, 1'b1};
        CODE_1: {out, valid} = {4'd1, 1'b1};
        CODE_2: {out, valid} = {4'd2, 1'b1};
        CODE_3: {out, valid} = {4'd3, 1'b1};
        CODE_4: {out, valid} = {4'd4, 1'b1};
        CODE_5: {out, valid} = {4'd5, 1'b1};
        CODE_6: {out, valid} = {4'd6, 1'b1};
        CODE_7: {out, valid} = {4'd7, 1'b1};
        CODE_8: {out, valid} = {4'd8, 1'b1};
        CODE_9: {out, valid} = {4'd9, 1'b1};
    endcase
end

endmodule