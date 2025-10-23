module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding
parameter STATE_A = 2'b10;
parameter STATE_B = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        STATE_A: begin
            if (x == 1'b0) begin
                next_state = STATE_A;
                z = 1'b0;
            end else begin
                next_state = STATE_B;
                z = 1'b1;
            end
        end
        STATE_B: begin
            next_state = STATE_B;
            z = ~x;
        end
        default: begin
            next_state = STATE_A;
            z = 1'b0;
        end
    endcase
end

endmodule