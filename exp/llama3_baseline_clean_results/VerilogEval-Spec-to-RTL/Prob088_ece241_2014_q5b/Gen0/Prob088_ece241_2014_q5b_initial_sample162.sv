module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states using parameters for readability
parameter STATE_A = 2'b01;
parameter STATE_B = 2'b10;

// Internal signal to hold the current state
reg [1:0] state;
reg [1:0] next_state;

// Output signal
reg z;

// Asynchronous reset to set the initial state
always @(areset or state) begin
    if(areset) begin
        state <= STATE_A;
    end else begin
        // Do nothing here since state transitions are handled in the clocked block
    end
end

// Sequential logic
always @(posedge clk) begin
    case(state)
        STATE_A: begin
            if(x == 1'b0) begin
                next_state <= STATE_A;
                z <= 1'b0;
            end else begin
                next_state <= STATE_B;
                z <= 1'b1;
            end
        end
        STATE_B: begin
            if(x == 1'b0) begin
                next_state <= STATE_B;
                z <= 1'b1;
            end else begin
                next_state <= STATE_B;
                z <= 1'b0;
            end
        end
        default: begin
            next_state <= STATE_A;
            z <= 1'b0;
        end
    endcase
    state <= next_state;
end

endmodule