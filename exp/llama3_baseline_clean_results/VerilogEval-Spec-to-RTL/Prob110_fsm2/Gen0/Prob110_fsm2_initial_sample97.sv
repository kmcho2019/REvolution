module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state, next_state;

// Define states
localparam OFF = 1'b0;
localparam ON = 1'b1;

// Determine next state
always_comb begin
    case(state)
        OFF: begin
            if(j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if(k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Update current state
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= OFF;
    end
    else begin
        state <= next_state;
    end
end

// Determine output based on current state
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule