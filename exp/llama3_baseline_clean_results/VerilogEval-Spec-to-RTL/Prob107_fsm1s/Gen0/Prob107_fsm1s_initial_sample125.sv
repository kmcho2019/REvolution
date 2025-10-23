module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
localparam [1:0] B = 2'b00, A = 2'b01;

reg [1:0] state, nextState;

// Sequential logic (state update)
always @ (posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= nextState;
    end
end

// Combinational logic (next state and output)
always @ (*) begin
    case (state)
        B: begin
            if (~in) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        A: begin
            if (~in) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        default: begin
            nextState = B; // Default state if any others are reached
        end
    endcase
end

// Output logic
assign out = (state == B) ? 1'b1 : 1'b0;

endmodule