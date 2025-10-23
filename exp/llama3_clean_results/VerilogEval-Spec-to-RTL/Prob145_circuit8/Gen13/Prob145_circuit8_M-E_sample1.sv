module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock) begin
    case (state)
        2'b00: // idle state
            begin
                p <= 0;
                if (a) begin
                    state <= 2'b01;
                    p <= a;
                end else begin
                    state <= 2'b00;
                end
            end
        2'b01: // active state
            begin
                if (a) begin
                    state <= 2'b01;
                    p <= a;
                end else begin
                    state <= 2'b10;
                end
            end
        2'b10: // active state with q high
            begin
                if (a) begin
                    state <= 2'b01;
                    p <= a;
                end else begin
                    state <= 2'b10;
                end
            end
        default:
            state <= 2'b00;
    endcase
end

always @(negedge clock) begin
    case (state)
        2'b01:
            begin
                if (!a) begin
                    state <= 2'b00;
                    q <= 0;
                end
            end
        2'b10:
            begin
                if (!a) begin
                    state <= 2'b00;
                    q <= 0;
                end else begin
                    q <= 1;
                end
            end
        default:
            q <= 0;
    endcase
end

initial begin
    state = 2'b00;
    p = 0;
    q = 0;
end

endmodule