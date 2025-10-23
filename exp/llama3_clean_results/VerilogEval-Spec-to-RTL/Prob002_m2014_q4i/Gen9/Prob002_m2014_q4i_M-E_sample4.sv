module TopModule(
    output out
);
    reg [1:0] dummy;
    always @(*) begin
        case (dummy)
            default: out = 0;
        endcase
    end
endmodule