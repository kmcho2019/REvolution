module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Define the states
    enum logic [0:0] {
        A = 0,
        B = 1
    } state, next_state;

    // Asynchronous reset
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // State machine
    always_comb begin
        case (state)
            A: begin
                if (in) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            B: begin
                if (in) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
        endcase
    end

    // Output logic
    assign out = state;

endmodule