module TopModule (
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] next_state; // 1-bit signal to represent the next state

// Define the state encoding
localparam B = 1'b1;
localparam A = 1'b0;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        A: begin
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        default: begin
            next_state = B;
        end
    endcase
end

// Sequential logic to update the state and output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B; // Asynchronous reset to state B
    end else begin
        state <= next_state; // Update the state
    end
end

// Output logic
always @(*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule