module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

parameter A = 2'b10;
parameter B = 2'b01;

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        A: begin
            if (~x) next_state = A;
            else next_state = B;
        end
        B: begin
            if (~x) next_state = B;
            else next_state = B;
        end
        default: next_state = A; // Default state in case of invalid state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) current_state <= A;
    else current_state <= next_state;
end

always @(*) begin
    case(current_state)
        A: z = ~x;
        B: z = ~x;
        default: z = 1'b0; // Default output in case of invalid state
    endcase
end

endmodule