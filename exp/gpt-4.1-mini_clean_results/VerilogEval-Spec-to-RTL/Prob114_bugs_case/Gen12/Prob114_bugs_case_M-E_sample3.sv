module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Define the recognized scancodes as parameters
localparam SC_0 = 8'h45;
localparam SC_1 = 8'h16;
localparam SC_2 = 8'h1E;
localparam SC_3 = 8'h26;
localparam SC_4 = 8'h25;
localparam SC_5 = 8'h2E;
localparam SC_6 = 8'h36;
localparam SC_7 = 8'h3D;
localparam SC_8 = 8'h3E;
localparam SC_9 = 8'h46;

always @(*) begin
    valid = 1'b0;
    out = 4'd0;

    case (code)
        SC_0: begin valid = 1'b1; out = 4'd0; end
        SC_1: begin valid = 1'b1; out = 4'd1; end
        SC_2: begin valid = 1'b1; out = 4'd2; end
        SC_3: begin valid = 1'b1; out = 4'd3; end
        SC_4: begin valid = 1'b1; out = 4'd4; end
        SC_5: begin valid = 1'b1; out = 4'd5; end
        SC_6: begin valid = 1'b1; out = 4'd6; end
        SC_7: begin valid = 1'b1; out = 4'd7; end
        SC_8: begin valid = 1'b1; out = 4'd8; end
        SC_9: begin valid = 1'b1; out = 4'd9; end
        default: begin valid = 1'b0; out = 4'd0; end
    endcase
end

endmodule