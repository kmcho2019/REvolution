module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        2'b00: begin // State A
            if (!in) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b01: begin // State B
            if (!in) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // State C
            if (!in) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b11;
            end
        end
        2'b11: begin // State D
            if (!in) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

always_comb begin
    case (state)
        2'b00, 2'b01, 2'b10: begin // States A, B, C
            out = 1'b0;
        end
        2'b11: begin // State D
            out = 1'b1;
        end
        default: begin
            out = 1'b0;
        end
    endcase
end

endmodule