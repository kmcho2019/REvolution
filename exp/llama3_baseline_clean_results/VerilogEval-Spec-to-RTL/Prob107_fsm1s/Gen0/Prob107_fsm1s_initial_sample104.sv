module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define state names
parameter B = 1'b0, A = 1'b1;

// Declare current and next state
reg [0:0] state;
reg [0:0] next_state;

// Define the state machine
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always @(*) begin
    case (state)
        B: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 1'b1;
        end
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 1'b0;
        end
    endcase
end

endmodule