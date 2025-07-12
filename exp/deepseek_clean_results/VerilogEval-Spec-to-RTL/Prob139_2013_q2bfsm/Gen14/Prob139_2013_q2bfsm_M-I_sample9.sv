module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

localparam A = 0, B = 1, C = 2, D = 3, G = 4, H = 5;
reg [2:0] state;
reg [2:0] x_shift;    // 3-bit shift register for x sequence
reg [1:0] timeout_cnt; // 2-bit timeout counter

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_shift <= 3'b000;
        timeout_cnt <= 2'b00;
    end else begin
        // Update x shift register in all states except permanent ones
        if (state != G && state != H) begin
            x_shift <= {x_shift[1:0], x};
        end

        case (state)
            A: state <= B;
            B: state <= C;
            C: begin
                if (x_shift == 3'b101) state <= D;
            end
            D: begin
                if (y) begin
                    state <= G;
                end else if (timeout_cnt == 2'b01) begin
                    state <= H;
                end
                timeout_cnt <= timeout_cnt + 1;
            end
            // G and H remain until reset
            default: state <= state;
        endcase
    end
end

assign f = (state == B);
assign g = (state == D) || (state == G);

endmodule