module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock or negedge clock) begin
    case (state)
        2'b00: begin
            if (clock && a) begin
                state <= 2'b01;
                p <= 1'b1;
            end else if (!clock && a) begin
                state <= 2'b10;
                q <= 1'b1;
            end else begin
                p <= 1'b0;
                q <= 1'b0;
            end
        end
        2'b01: begin
            if (clock && !a) begin
                state <= 2'b00;
                p <= 1'b0;
            end else if (!clock && a) begin
                state <= 2'b11;
                q <= 1'b1;
            end
        end
        2'b10: begin
            if (clock && !a) begin
                state <= 2'b00;
                q <= 1'b0;
            end else if (clock && a) begin
                state <= 2'b11;
                p <= 1'b1;
            end
        end
        2'b11: begin
            if (clock && !a) begin
                state <= 2'b00;
                p <= 1'b0;
                q <= 1'b0;
            end else if (!clock && !a) begin
                state <= 2'b10;
                p <= 1'b0;
            end
        end
    endcase
end

endmodule