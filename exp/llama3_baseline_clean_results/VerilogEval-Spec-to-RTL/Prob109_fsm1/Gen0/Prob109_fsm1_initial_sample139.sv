module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
enum {A, B} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for state transitions and output
always @(*) begin
    case (state)
        A: begin
            if (in == 1'b1) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 1'b0;
        end
        B: begin
            if (in == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 1'b1;
        end
    endcase
end

endmodule