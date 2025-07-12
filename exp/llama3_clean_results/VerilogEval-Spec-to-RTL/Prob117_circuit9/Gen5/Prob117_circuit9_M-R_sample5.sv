module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

enum logic [2:0] {IDLE, RESET, INCREMENT, WRAP} state;

always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (a) begin
                state <= RESET;
            end else if (q == 6) begin
                state <= WRAP;
            end else begin
                state <= INCREMENT;
            end
        end
        RESET: state <= IDLE;
        INCREMENT: state <= IDLE;
        WRAP: state <= IDLE;
        default: state <= IDLE;
    endcase
end

always @(*) begin
    case (state)
        IDLE: q = q;
        RESET: q = 4;
        INCREMENT: q = q + 1;
        WRAP: q = 0;
        default: q = q;
    endcase
end

initial begin
    q <= 4;
    state <= IDLE;
end

endmodule