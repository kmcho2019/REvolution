module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as an enum
enum logic [0:0] {A, B} state, next_state;

// Asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always_comb begin
    case(state)
        A: begin
            if(in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if(in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 1;
        end
        default: begin
            next_state = B;
            out = 1;
        end
    endcase
end

endmodule