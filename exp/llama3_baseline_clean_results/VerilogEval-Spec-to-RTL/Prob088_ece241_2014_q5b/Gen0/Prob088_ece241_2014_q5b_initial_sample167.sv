module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state, next_state;

// Define the states
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

// Initialize state to STATE_A on reset
initial state = STATE_A;

// Combinational logic for next state and output
always @(*) begin
    case(state)
        STATE_A: begin
            if(x) begin
                next_state = STATE_B;
                z = 1'b1;
            end else begin
                next_state = STATE_A;
                z = 1'b0;
            end
        end
        STATE_B: begin
            if(x) begin
                next_state = STATE_B;
                z = 1'b0;
            end else begin
                next_state = STATE_B;
                z = 1'b1;
            end
        end
        default: begin
            next_state = STATE_A; // Default to STATE_A for any other state
            z = 1'b0;
        end
    endcase
end

// Sequential logic for state update on positive edge of clk
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

endmodule