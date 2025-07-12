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
                p <= 1;
            end else if (!clock && a) begin
                state <= 2'b10;
                q <= 0;
            end
        end
        2'b01: begin
            if (!clock) begin
                state <= 2'b00;
                p <= 0;
            end
        end
        2'b10: begin
            if (clock && a) begin
                state <= 2'b11;
                p <= 1;
                q <= 1;
            end
        end
        2'b11: begin
            if (!clock && a) begin
                state <= 2'b10;
                q <= 0;
            end else if (!a) begin
                state <= 2'b00;
                p <= 0;
                q <= 0;
            end
        end
    endcase
end

endmodule