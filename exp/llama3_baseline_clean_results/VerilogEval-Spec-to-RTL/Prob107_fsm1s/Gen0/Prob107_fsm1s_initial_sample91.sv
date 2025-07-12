module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

enum logic [0:0] { B, A } state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        B: begin
            out = 1;
            if (in == 0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            out = 0;
            if (in == 0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: begin
            out = 1;
            next_state = B;
        end
    endcase
end

endmodule