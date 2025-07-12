module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 3-bit state register to encode states A to F
reg [1:0] seq_cnt; // Counter for sequence detection of x
reg [1:0] y_cnt; // Counter for waiting for y

parameter A = 3'b000, // Initial state
          B = 3'b001, // State after reset de-asserted
          C = 3'b010, // Waiting for sequence 1, 0, 1 on x
          D = 3'b011, // Waiting for y to become 1
          E = 3'b100, // g set to 1 permanently
          F = 3'b101; // g set to 0 permanently

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= A;
        seq_cnt <= 0;
        y_cnt <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                f <= 0;
                g <= 0;
            end
            B: begin
                state <= C;
                f <= 1;
                g <= 0;
            end
            C: begin
                if (x == 1 && seq_cnt == 0) begin
                    seq_cnt <= seq_cnt + 1;
                end else if (x == 0 && seq_cnt == 1) begin
                    seq_cnt <= seq_cnt + 1;
                end else if (x == 1 && seq_cnt == 2) begin
                    seq_cnt <= 0;
                    state <= D;
                end else begin
                    seq_cnt <= 0;
                end
                f <= 0;
                g <= 0;
            end
            D: begin
                if (y == 1) begin
                    state <= E;
                    y_cnt <= 0;
                end else begin
                    y_cnt <= y_cnt + 1;
                    if (y_cnt == 2) begin
                        state <= F;
                    end
                end
                f <= 0;
                g <= 1;
            end
            E: begin
                f <= 0;
                g <= 1;
            end
            F: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule