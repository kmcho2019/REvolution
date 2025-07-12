module TopModule (
    input         clk,
    input         areset,
    input         x,
    output        z
);

// Define states using one-hot encoding
reg [1:0] state;
reg [1:0] next_state;

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

// Reset logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        A: begin
            if (x == 0) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            next_state <= B;
        end
        default: begin
            next_state <= A;
        end
    endcase
end

// Output logic
assign z = (state == A) ? x : 1;

endmodule