module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic next_state; // Next state
    logic output; // Output based on the state

    // Combinational logic for next state and output
    always_comb begin
        case(state)
            1'b0: begin // State A
                next_state = in ? 1'b0 : 1'b1;
                output = 1'b0;
            end
            1'b1: begin // State B
                next_state = in ? 1'b1 : 1'b0;
                output = 1'b1;
            end
            default: begin
                next_state = 1'b1; // Default next state
                output = 1'b1; // Default output
            end
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Assign output
    assign out = output;

endmodule