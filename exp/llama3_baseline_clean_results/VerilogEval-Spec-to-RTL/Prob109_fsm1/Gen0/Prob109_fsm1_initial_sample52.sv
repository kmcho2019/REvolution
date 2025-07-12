module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states of the machine
reg [1:0] current_state;
reg [1:0] next_state;

// Define the states
parameter B = 2'b01;
parameter A = 2'b10;

// Asynchronous reset
always @(posedge areset or negedge areset) begin
    if (areset) begin
        current_state <= B;
    end
end

// State transitions
always @(posedge clk) begin
    if (~areset) begin
        current_state <= next_state;
    end else begin
        current_state <= B;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
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
        default: next_state = B;
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule