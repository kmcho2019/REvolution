module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// Initialize current state to state A (2'b01) on reset
initial current_state = 2'b01;

// State A = 2'b01, State B = 2'b10
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= 2'b01; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        2'b01: begin // State A
            if(x == 0) begin
                next_state = 2'b01; // Stay in state A
                z = 1'b0;
            end else begin
                next_state = 2'b10; // Go to state B
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            if(x == 0) begin
                next_state = 2'b10; // Stay in state B
                z = 1'b1;
            end else begin
                next_state = 2'b10; // Stay in state B
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b01; // Default to state A
            z = 1'b0;
        end
    endcase
end

endmodule