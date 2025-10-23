module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Use a single, large combinational logic block to map the current state and input to the next state
    always @(*) begin
        case ({y, w})
            7'b0000010: begin Y1 = 1'b1; Y3 = 1'b0; end // A(0) to B
            7'b0000011: begin Y1 = 1'b0; Y3 = 1'b0; end // A(0) to A
            7'b0000100: begin Y1 = 1'b0; Y3 = 1'b0; end // B(0) to D
            7'b0000101: begin Y1 = 1'b0; Y3 = 1'b1; end // B(0) to C
            7'b0001000: begin Y1 = 1'b0; Y3 = 1'b0; end // C(0) to D
            7'b0001001: begin Y1 = 1'b0; Y3 = 1'b1; end // C(0) to E
            7'b0010000: begin Y1 = 1'b0; Y3 = 1'b1; end // D(0) to A
            7'b0010001: begin Y1 = 1'b0; Y3 = 1'b0; end // D(0) to F
            7'b0100000: begin Y1 = 1'b0; Y3 = 1'b0; end // E(0) to D
            7'b0100001: begin Y1 = 1'b0; Y3 = 1'b1; end // E(1) to E
            7'b1000000: begin Y1 = 1'b0; Y3 = 1'b0; end // F(0) to D
            7'b1000001: begin Y1 = 1'b0; Y3 = 1'b1; end // F(1) to C
            default: begin Y1 = 1'b0; Y3 = 1'b0; end
        endcase
    end

endmodule