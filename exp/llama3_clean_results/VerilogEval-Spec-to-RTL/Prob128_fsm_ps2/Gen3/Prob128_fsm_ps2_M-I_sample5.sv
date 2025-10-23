module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

reg [1:0] state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin
                if (in[3]) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done <= 0;
            end
            1: begin
                state <= 2;
                done <= 0;
            end
            2: begin
                state <= 3;
                done <= 0;
            end
            3: begin
                state <= 0;
                done <= 1;
            end
        endcase
    end
end

endmodule