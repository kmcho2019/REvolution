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
            end else begin
                state <= 0;
            end
        end
        1: begin
            if (a) begin
                state <= 1;
            end else begin
                state <= 2;
            end
        end
        2: begin
            if (a) begin
                state <= 1;
            end else begin
                state <= 2;
            end
        end
        default: begin
            state <= 0;
        end
    endcase
end

assign p = (clock && a);
assign q = (!clock && (state == 1 || state == 2));

endmodule