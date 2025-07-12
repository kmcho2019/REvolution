module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare current state
reg [1:0] current_state;

// Initialize current state to A
initial current_state = A;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to state A
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (~in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            B: begin
                if (~in) begin
                    current_state <= C;
                end else begin
                    current_state <= B;
                end
            end
            C: begin
                if (~in) begin
                    current_state <= A;
                end else begin
                    current_state <= D;
                end
            end
            D: begin
                if (~in) begin
                    current_state <= C;
                end else begin
                    current_state <= B;
                end
            end
        endcase
    end
end

// Output logic
always @(current_state) begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule