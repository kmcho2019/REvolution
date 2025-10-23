module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg A, B; // Current state
reg next_A, next_B; // Next state
reg next_z; // Next output

// One-hot encoding: only one of A or B should be 1 at any time
// Initial state is A
always @(posedge clk or posedge areset) begin
    if (areset) begin
        A <= 1'b1;
        B <= 1'b0;
    end else begin
        A <= next_A;
        B <= next_B;
    end
end

// Combinational logic to determine next state and output
always @(*) begin
    case ({A, B}) // Current state
        2'b10: begin // In state A
            if (x) begin
                next_A = 1'b0;
                next_B = 1'b1;
                next_z = 1'b1;
            end else begin
                next_A = 1'b1;
                next_B = 1'b0;
                next_z = 1'b0;
            end
        end
        2'b01: begin // In state B
            next_A = 1'b0;
            next_B = 1'b1;
            next_z = ~x; // z is inverse of x
        end
        default: begin // Invalid state, should not happen
            next_A = 1'b1;
            next_B = 1'b0;
            next_z = 1'b0;
        end
    endcase
end

// Output logic
assign z = next_z;

endmodule