module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // default output value
    for (int i = 3; i >= 0; i--) begin
        if (in[i]) begin
            // assign position based on current index
            case (i)
                3: pos = 2'b11;
                2: pos = 2'b10;
                1: pos = 2'b01;
                0: pos = 2'b00;
            endcase
            break; // exit the loop as soon as '1' bit is found
        end
    end
end

endmodule