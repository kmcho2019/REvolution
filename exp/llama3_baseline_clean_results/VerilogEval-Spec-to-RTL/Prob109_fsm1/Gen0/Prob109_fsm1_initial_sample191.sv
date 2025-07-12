module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

reg [0:0] current_state;
reg [0:0] next_state;

// Define the states
localparam A = 0;
localparam B = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A: begin
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B;
    endcase

    // Output is determined by the current state
    case (current_state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule