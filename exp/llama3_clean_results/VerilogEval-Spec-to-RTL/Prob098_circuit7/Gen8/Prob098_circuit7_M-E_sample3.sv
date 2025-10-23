module TopModule(
    input clk,
    input a,
    output reg q
);

// Define states
reg [1:0] state = 2'b01; // Initialize state to STATE_1 (2'b01)
localparam STATE_1 = 2'b01;
localparam STATE_0 = 2'b00;

// State machine logic
always @(posedge clk) begin
    case(state)
        STATE_1: begin
            if (~a) begin
                state <= STATE_1; // Remain in STATE_1 if a is 0
                q <= 1'b1;
            end else begin
                state <= STATE_0; // Move to STATE_0 if a is 1
                q <= 1'b1; // q remains 1 during this transition
            end
        end
        STATE_0: begin
            state <= STATE_0; // Remain in STATE_0
            q <= 1'b0; // q is 0 in STATE_0
        end
        default: begin
            state <= STATE_1; // Default to STATE_1
            q <= 1'b1;
        end
    endcase
end

endmodule