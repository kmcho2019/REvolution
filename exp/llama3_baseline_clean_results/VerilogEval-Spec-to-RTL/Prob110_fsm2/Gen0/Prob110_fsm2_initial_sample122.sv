module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [1:0] state; // 0: OFF, 1: ON
reg [1:0] next_state;

always @(*) begin
    case (state)
        0: begin // OFF
            if (j == 1'b1) begin
                next_state = 1; // ON
            end else begin
                next_state = 0; // OFF
            end
        end
        1: begin // ON
            if (k == 1'b1) begin
                next_state = 0; // OFF
            end else begin
                next_state = 1; // ON
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // OFF
        out <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            0: out <= 1'b0; // OFF
            1: out <= 1'b1; // ON
        endcase
    end
end

endmodule