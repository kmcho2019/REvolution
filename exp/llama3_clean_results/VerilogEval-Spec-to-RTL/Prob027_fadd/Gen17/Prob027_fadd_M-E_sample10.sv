// Top Module
module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    case ({a, b, cin})
        3'b000: begin cout = 0; sum = 0; end
        3'b001: begin cout = 0; sum = 1; end
        3'b010: begin cout = 0; sum = 1; end
        3'b011: begin cout = 1; sum = 0; end
        3'b100: begin cout = 0; sum = 1; end
        3'b101: begin cout = 1; sum = 0; end
        3'b110: begin cout = 1; sum = 0; end
        3'b111: begin cout = 1; sum = 1; end
    endcase
end

endmodule