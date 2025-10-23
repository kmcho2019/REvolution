module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    // Define constants for scancodes and their corresponding output values
    parameter SC_0 = 8'h45;
    parameter SC_1 = 8'h16;
    parameter SC_2 = 8'h1e;
    parameter SC_3 = 8'h26;
    parameter SC_4 = 8'h25;
    parameter SC_5 = 8'h2e;
    parameter SC_6 = 8'h36;
    parameter SC_7 = 8'h3d;
    parameter SC_8 = 8'h3e;
    parameter SC_9 = 8'h46;

    always @(*) begin
        out = 4'd0;
        valid = 1'b1;
        case (code)
            SC_0: out = 4'd0;
            SC_1: out = 4'd1;
            SC_2: out = 4'd2;
            SC_3: out = 4'd3;
            SC_4: out = 4'd4;
            SC_5: out = 4'd5;
            SC_6: out = 4'd6;
            SC_7: out = 4'd7;
            SC_8: out = 4'd8;
            SC_9: out = 4'd9;
            default: valid = 1'b0;
        endcase
    end

endmodule