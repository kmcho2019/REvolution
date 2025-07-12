module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

// Internal state definition
typedef enum logic {
    NORMAL_MODE,
    RESET_MODE
} state_t;

state_t current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;
        current_state <= RESET_MODE;
    end
    else begin
        case (current_state)
            RESET_MODE: begin
                q <= 8'b0;
                current_state <= NORMAL_MODE;
            end
            NORMAL_MODE: begin
                q <= d;  // Parallel load
            end
        endcase
    end
end

endmodule