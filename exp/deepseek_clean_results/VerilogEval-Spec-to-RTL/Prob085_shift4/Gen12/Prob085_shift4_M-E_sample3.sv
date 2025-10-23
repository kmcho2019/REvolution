module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// State encoding
typedef enum logic [1:0] {
    RESET,
    LOAD,
    SHIFT
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= RESET;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        RESET: next_state = (load) ? LOAD : (ena) ? SHIFT : RESET;
        LOAD: next_state = (load) ? LOAD : (ena) ? SHIFT : RESET;
        SHIFT: next_state = (load) ? LOAD : (ena) ? SHIFT : RESET;
        default: next_state = RESET;
    endcase
end

// Output logic
always @(posedge clk) begin
    case (current_state)
        RESET: q <= 4'b0;
        LOAD: q <= data;
        SHIFT: q <= {1'b0, q[3:1]};
        default: q <= 4'b0;
    endcase
end

endmodule