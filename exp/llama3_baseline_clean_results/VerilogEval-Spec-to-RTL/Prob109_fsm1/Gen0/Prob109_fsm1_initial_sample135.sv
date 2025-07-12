module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Enum for the states
enum logic [0:0] {A, B} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case(state)
        A: begin
            if(in) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            if(in) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
    endcase
end

// Combinational logic for output
always @(*) begin
    case(state)
        A: out <= 0;
        B: out <= 1;
    endcase
end

endmodule