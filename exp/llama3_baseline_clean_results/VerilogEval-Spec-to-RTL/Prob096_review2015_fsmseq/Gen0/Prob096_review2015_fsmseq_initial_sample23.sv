module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Enum for the states
typedef enum logic [2:0] {
    idle,
    seq1,
    seq2,
    seq3,
    found
} state_t;

// Current state
state_t current_state;

// Initialize current state
initial current_state = idle;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= idle;
        start_shifting <= 0;
    end else begin
        case (current_state)
            idle: begin
                if (data == 1) begin
                    current_state <= seq1;
                end else begin
                    current_state <= idle;
                end
            end
            seq1: begin
                if (data == 1) begin
                    current_state <= seq2;
                end else if (data == 0) begin
                    current_state <= idle;
                end else begin
                    current_state <= seq1;
                end
            end
            seq2: begin
                if (data == 0) begin
                    current_state <= seq3;
                end else begin
                    current_state <= idle;
                end
            end
            seq3: begin
                if (data == 1) begin
                    current_state <= found;
                end else begin
                    current_state <= idle;
                end
            end
            found: begin
                start_shifting <= 1;
            end
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (current_state == found) begin
        start_shifting <= 1;
    end else if (reset) begin
        start_shifting <= 0;
    end
end

endmodule