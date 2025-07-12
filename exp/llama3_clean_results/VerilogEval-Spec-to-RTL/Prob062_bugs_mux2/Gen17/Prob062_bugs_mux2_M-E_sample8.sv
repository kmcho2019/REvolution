module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output       out
);

    reg [7:0] temp_out;

    always @(a or b or sel) begin
        case (sel)
            1'b0: temp_out = a;
            1'b1: temp_out = b;
            default: temp_out = 8'b0; // Default case for invalid sel value
        endcase
    end

    assign out = temp_out[0]; // Select the least significant bit as output

endmodule