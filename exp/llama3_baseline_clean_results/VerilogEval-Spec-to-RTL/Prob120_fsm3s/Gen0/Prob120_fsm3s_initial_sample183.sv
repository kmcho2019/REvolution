module TopModule (
    input  clk,         // clock
    input  reset,       // synchronous active high reset
    input  in,          // input signal
    output out          // output signal
);

// Define states
localparam [1:0] A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
reg [1:0] current_state, next_state;

// Initialize current state to A at reset
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic based on the current state and input
always @(*) begin
    case (current_state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        default: next_state = A; // Default state to A for any other value
    endcase
end

// Output logic based on the current state
assign out = (current_state == D) ? 1'b1 : 1'b0;

endmodule