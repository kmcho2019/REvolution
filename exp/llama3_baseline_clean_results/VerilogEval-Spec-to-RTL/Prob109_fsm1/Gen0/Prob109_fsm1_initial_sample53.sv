module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] state; // Using 2 bits to represent the two states A and B
reg [1:0] next_state;

// Define the states
parameter A = 2'b01;
parameter B = 2'b10;

always @(*) begin
    case (state)
        A: begin
            if (~in) next_state = B;
            else next_state = A;
            out = 0;
        end
        B: begin
            if (in) next_state = B;
            else next_state = A;
            out = 1;
        end
        default: begin
            next_state = B;
            out = 1;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) state <= B;
    else state <= next_state;
end

endmodule