module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state combinational logic using if-else for simpler mux trees
    always @(*) begin
        next_state = 4'b0000; // default to zero to avoid latches

        if (current_state == A) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end else if (current_state == B) begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end else if (current_state == C) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = D;
        end else if (current_state == D) begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end else begin
            next_state = A; // safety fallback in case of invalid state
        end
    end

    // Output is high only in state D (one-hot encoding)
    assign out = current_state[3];

endmodule