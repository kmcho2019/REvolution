module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b01: begin // State A
            if(x == 1'b0) begin
                next_state = 2'b01;
                z = 1'b0;
            end else begin
                next_state = 2'b10;
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            next_state = 2'b10;
            z = ~x;
        end
        default: begin // Invalid state
            next_state = 2'b01;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule