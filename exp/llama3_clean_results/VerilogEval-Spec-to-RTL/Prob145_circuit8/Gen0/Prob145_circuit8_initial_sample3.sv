module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @ (posedge clock or negedge clock) begin
    if (!clock) begin
        p <= 0;
        if (a) begin
            if (state == 2'b00) begin
                state <= 2'b01;
            end else if (state == 2'b01) begin
                state <= 2'b10;
            end else if (state == 2'b10) begin
                state <= 2'b11;
            end else begin
                state <= 2'b11;
            end
        end else begin
            state <= 2'b00;
        end
    end else begin
        if (a) begin
            p <= 1;
        end else begin
            p <= 0;
        end
        if (state == 2'b11) begin
            q <= 1;
        end else begin
            q <= 0;
        end
    end
end

endmodule