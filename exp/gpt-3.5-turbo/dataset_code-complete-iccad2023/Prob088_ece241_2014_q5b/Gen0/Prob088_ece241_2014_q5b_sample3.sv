module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// State encoding
parameter A = 2'b01;
parameter B = 2'b10;

// State registers
reg [1:0] state, next_state;

// State transition and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Reset to state A
        z <= 0;     // Output z as 0
    end
    else begin
        state <= next_state;
        case (state)
            A: begin
                if (x) begin
                    next_state = B;
                    z = 1;
                end
                else begin
                    next_state = A;
                    z = 0;
                end
            end
            B: begin
                if (x) begin
                    next_state = B;
                    z = 0;
                end
                else begin
                    next_state = B;
                    z = 1;
                end
            end
        endcase
    end
end

endmodule