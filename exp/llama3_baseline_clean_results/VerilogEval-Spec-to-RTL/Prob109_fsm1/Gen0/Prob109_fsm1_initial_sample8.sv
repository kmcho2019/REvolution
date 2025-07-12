module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state;  // current state
reg [0:0] next_state;  // next state

// Define the states
parameter A = 0, B = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        default: next_state = B;  // default state
    endcase
end

always @(*) begin
    case (state)
        A: out = 0;
        B: out = 1;
        default: out = 1;  // default output
    endcase
end

endmodule