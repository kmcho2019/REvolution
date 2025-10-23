module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
enum logic [0:0] {A, B} state, next_state;

// Initialize the state
initial state = B;

// Asynchronous reset
always @(posedge areset) begin
    state <= B;
end

// Synchronous logic
always @(posedge clk) begin
    if (~areset) begin
        case (state)
            A: begin
                if (~in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            B: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            default: state <= B;
        endcase
    end
end

// Moore output
assign out = state == B;
endmodule