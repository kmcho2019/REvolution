module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {B, A} state, nextState;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= nextState;
    end
end

// Next state and output logic
always_comb begin
    case (state)
        B: begin
            if (in == 0) begin
                nextState = A;
            end else begin
                nextState = B;
            end
            out = 1'b1;
        end
        A: begin
            if (in == 0) begin
                nextState = B;
            end else begin
                nextState = A;
            end
            out = 1'b0;
        end
        default: begin
            nextState = B;
            out = 1'b1;
        end
    endcase
end

endmodule