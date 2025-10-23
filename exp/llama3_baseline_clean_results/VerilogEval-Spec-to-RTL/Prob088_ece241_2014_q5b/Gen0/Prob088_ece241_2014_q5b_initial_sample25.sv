module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

// One-hot encoding for states
reg [1:0] state;
reg [1:0] next_state;

// State encoding
parameter A = 2'b01;
parameter B = 2'b10;

// Initialize state to A on reset
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
            if (~x) begin
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
always @(*) begin
    case (state)
        A: begin
            z <= ~x;
        end
        B: begin
            z <= ~x;
        end
        default: begin
            z <= 1'b0;
        end
    endcase
end

endmodule