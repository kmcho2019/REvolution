module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] counter; // 2-bit counter register

always @ (posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
    end else begin
        case (counter)
            2'b00: begin
                if (in[3]) begin
                    counter <= 2'b01;
                end
            end
            2'b01: begin
                counter <= 2'b10;
            end
            2'b10: begin
                counter <= 2'b11;
            end
            2'b11: begin
                counter <= 2'b00;
            end
        endcase
    end
end

assign done = (counter == 2'b11);

endmodule