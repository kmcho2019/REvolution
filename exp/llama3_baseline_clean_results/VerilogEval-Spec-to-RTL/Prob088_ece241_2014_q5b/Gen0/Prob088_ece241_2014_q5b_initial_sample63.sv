module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Initialize the state
initial state = 2'b01;

// Combinational logic to determine the next state and the output
always @(*)
begin
    case(state)
        2'b01: // State A
        begin
            if(x == 1'b0)
            begin
                next_state = 2'b01; // Stay in state A
                z = 1'b0;
            end
            else
            begin
                next_state = 2'b10; // Go to state B
                z = 1'b1;
            end
        end
        2'b10: // State B
        begin
            if(x == 1'b0)
            begin
                next_state = 2'b10; // Stay in state B
                z = 1'b1;
            end
            else
            begin
                next_state = 2'b10; // Stay in state B
                z = 1'b0;
            end
        end
        default: // Invalid state
        begin
            next_state = 2'b01; // Reset to state A
            z = 1'b0;
        end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset)
begin
    if(areset)
    begin
        state <= 2'b01; // Asynchronous reset to state A
    end
    else
    begin
        state <= next_state;
    end
end

endmodule