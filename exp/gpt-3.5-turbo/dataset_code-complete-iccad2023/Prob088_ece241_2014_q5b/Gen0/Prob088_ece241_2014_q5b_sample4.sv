module MealyMachine (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state, next_state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Initialize to state A
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            2'b01: begin // State A
                if (x == 1) begin
                    next_state = 2'b10; // Transition to B
                    z = 1;
                end else begin
                    next_state = 2'b01; // Stay in A
                    z = 0;
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
        endcase
    end

endmodule