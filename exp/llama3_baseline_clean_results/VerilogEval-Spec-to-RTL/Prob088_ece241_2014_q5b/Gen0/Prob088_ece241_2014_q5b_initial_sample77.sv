module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state, next_state;
reg z_reg, next_z;

// Define states in one-hot encoding
parameter A = 2'b01;
parameter B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        z_reg <= 1'b0;
    end else begin
        state <= next_state;
        z_reg <= next_z;
    end
end

always @(*) begin
    next_state = state;
    next_z = 1'b0;
    
    case(state)
        A: begin
            next_z = x;
            if (x == 1'b1) next_state = B;
        end
        B: begin
            next_z = ~x;
            next_state = B;
        end
        default: next_state = A; // Should not reach here, but for simulation purposes
    endcase
end

assign z = z_reg;

endmodule