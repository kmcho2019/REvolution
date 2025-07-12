module TopModule (
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

reg [3:0] key_value;

always @(*) begin
    out = 4'd0; 
    valid = 1'b0; 
    key_value = 4'd0;

    if (code == 8'h45) key_value = 4'd0;
    else if (code == 8'h16) key_value = 4'd1;
    else if (code == 8'h1e) key_value = 4'd2;
    else if (code == 8'h26) key_value = 4'd3;
    else if (code == 8'h25) key_value = 4'd4;
    else if (code == 8'h2e) key_value = 4'd5;
    else if (code == 8'h36) key_value = 4'd6;
    else if (code == 8'h3d) key_value = 4'd7;
    else if (code == 8'h3e) key_value = 4'd8;
    else if (code == 8'h46) key_value = 4'd9;

    if (key_value!= 4'd0) begin
        out = key_value;
        valid = 1'b1;
    end
end

endmodule