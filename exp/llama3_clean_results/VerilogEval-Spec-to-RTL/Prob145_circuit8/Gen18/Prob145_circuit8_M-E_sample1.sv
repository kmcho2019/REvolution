module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock) begin
    case (state)
        2'b00: begin // State 0
            p <= 0;
            if (a) begin
                state <= 2'b01;
            end
        end
        2'b01: begin // State 1
            p <= a;
            state <= 2'b01;
        end
        default: state <= 2'b00;
    endcase
end

always @(negedge clock) begin
    case (state)
        2'b00: begin
            q <= 0;
        end
        2'b01: begin
            if (!a) begin
                state <= 2'b00;
                q <= 0;
            end else begin
                q <= 1;
            end
        end
        default: q <= 0;
    endcase
end

endmodule