module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        2'b01: begin // State A
            if (x == 0) begin
                next_state = 2'b01; // Stay in A
                z = 0;
            end else begin
                next_state = 2'b10; // Go to B
                z = 1;
            end
        end
        2'b10: begin // State B
            if (x == 0) begin
                next_state = 2'b10; // Stay in B
                z = 1;
            end else begin
                next_state = 2'b10; // Stay in B
                z = 0;
            end
        end
        default: begin
            next_state = 2'b01; // Default to A
            z = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b01; // Reset to A
    end else begin
        current_state <= next_state;
    end
end

endmodule