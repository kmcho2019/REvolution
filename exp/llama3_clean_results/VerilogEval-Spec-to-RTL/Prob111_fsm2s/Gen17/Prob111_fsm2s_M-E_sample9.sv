module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] counter;

always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00;
        out <= 1'b0;
    end else begin
        case (counter)
            2'b00: begin
                if (j) begin
                    counter <= 2'b01;
                    out <= 1'b1;
                end else begin
                    counter <= 2'b00;
                    out <= 1'b0;
                end
            end
            2'b01: begin
                if (~k) begin
                    counter <= 2'b01;
                    out <= 1'b1;
                end else begin
                    counter <= 2'b00;
                    out <= 1'b0;
                end
            end
            default: begin
                counter <= 2'b00;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule