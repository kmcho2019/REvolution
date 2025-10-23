module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 1'b0;
parameter B = 1'b1;

// Current state
reg [0:0] current_state;

// Initialize state
initial current_state = B;

// Asynchronous reset
always @(posedge areset or negedge clk) begin
    if (areset) begin
        current_state <= B;
    end else begin
        // State transitions
        case (current_state)
            A: begin
                if (in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if (in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: current_state <= B;
        endcase
    end
end

// Output logic
always @(*) begin
    case (current_state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule