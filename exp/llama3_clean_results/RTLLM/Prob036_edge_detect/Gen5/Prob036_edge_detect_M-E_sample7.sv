module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (a) begin
                    state <= 2'b01; // RISE
                    rise <= 1'b1;
                    down <= 1'b0;
                end else begin
                    state <= 2'b00; // IDLE
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b01: begin // RISE
                state <= 2'b10; // STABLE
                rise <= 1'b0;
                down <= 1'b0;
            end
            2'b10: begin // STABLE
                if (~a) begin
                    state <= 2'b11; // FALL
                    rise <= 1'b0;
                    down <= 1'b1;
                end else begin
                    state <= 2'b10; // STABLE
                    rise <= 1'b0;
                    down <= 1'b0;
                end
            end
            2'b11: begin // FALL
                state <= 2'b10; // STABLE
                rise <= 1'b0;
                down <= 1'b0;
            end
        endcase
    end
end

endmodule