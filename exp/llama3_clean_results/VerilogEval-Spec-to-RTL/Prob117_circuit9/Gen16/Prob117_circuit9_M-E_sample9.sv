module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;

initial begin
    state = 4;
    q = 4;
end

always @(posedge clk) begin
    if (a) begin
        state <= 4;
        q <= 4;
    end else begin
        case (state)
            4: begin
                state <= 5;
                q <= 5;
            end
            5: begin
                state <= 6;
                q <= 6;
            end
            6: begin
                state <= 0;
                q <= 0;
            end
            0: begin
                state <= 1;
                q <= 1;
            end
            1: begin
                state <= 2;
                q <= 2;
            end
            2: begin
                state <= 3;
                q <= 3;
            end
            3: begin
                state <= 4;
                q <= 4;
            end
            default: begin
                state <= 4;
                q <= 4;
            end
        endcase
    end
end

endmodule