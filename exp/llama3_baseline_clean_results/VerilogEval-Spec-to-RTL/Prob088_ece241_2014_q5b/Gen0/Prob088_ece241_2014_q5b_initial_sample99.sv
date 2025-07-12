module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // one-hot encoding
reg [1:0] next_state;

// asynchronous reset
always @(posedge clk or posedge areset)
begin
    if (areset) begin
        state <= 2'b01; // reset to state A
    end else begin
        state <= next_state;
    end
end

// next state logic
always @(*)
begin
    case (state)
        2'b01: // state A
            begin
                if (x == 1'b0) begin
                    next_state = 2'b01; // stay in state A
                    z = 1'b0;
                end else begin
                    next_state = 2'b10; // transition to state B
                    z = 1'b1;
                end
            end
        2'b10: // state B
            begin
                if (x == 1'b0) begin
                    next_state = 2'b10; // stay in state B
                    z = 1'b1;
                end else begin
                    next_state = 2'b10; // stay in state B
                    z = 1'b0;
                end
            end
        default: // should never happen
            begin
                next_state = 2'b01; // reset to state A
                z = 1'b0;
            end
    endcase
end

endmodule