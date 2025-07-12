module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    case ({p,q,a})
        3'b000: begin p <= 0; q <= 0; end // p=0 q=0 a=0
        3'b001: begin p <= 1; q <= 0; end // p=0 q=0 a=1
        3'b100: begin p <= 0; q <= 0; end // p=1 q=0 a=0
        3'b101: begin p <= 1; q <= 1; end // p=1 q=0 a=1
        3'b110: begin p <= 0; q <= 1; end // p=1 q=1 a=0
        3'b111: begin p <= 1; q <= 1; end // p=1 q=1 a=1
        3'b010: begin p <= 0; q <= 0; end // p=0 q=1 a=0
        3'b011: begin p <= 1; q <= 1; end // p=0 q=1 a=1
        default: begin p <= 0; q <= 0; end // default safe state
    endcase
end

endmodule