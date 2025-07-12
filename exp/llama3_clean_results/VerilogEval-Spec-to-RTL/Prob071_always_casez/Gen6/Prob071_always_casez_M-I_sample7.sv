module TopModule(
    input  [7:0] in, 
    output reg [2:0] pos
);

always @(in) begin
    casez (in)
        8'b10000000: pos = 3'd7;
        8'b1000000?: pos = 3'd6;
        8'b100000??: pos = 3'd5;
        8'b10000???: pos = 3'd4;
        8'b1000????: pos = 3'd3;
        8'b10??????: pos = 3'd2;
        8'b1??????? : pos = 3'd1;
        8'b???????1 : pos = 3'd0;
        default: pos = 3'd0; // If no '1' is found
    endcase
end

endmodule