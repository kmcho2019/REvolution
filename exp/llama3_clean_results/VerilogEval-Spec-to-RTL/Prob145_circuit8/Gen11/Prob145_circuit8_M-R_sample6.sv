module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state = 0; // Initial state

always @(posedge clock) begin
    case (state)
        0: begin
            if (a) begin
                state <= 1;
                p <= 1;
            end else begin
                state <= 0;
                p <= 0;
            end
        end
        1: begin
            if (!a) begin
                state <= 0;
                p <= 0;
            end else begin
                state <= 1;
                p <= 1;
            end
        end
        default: begin
            state <= 0;
            p <= 0;
        end
    endcase
end

assign q = (state == 1) && (!clock);

endmodule