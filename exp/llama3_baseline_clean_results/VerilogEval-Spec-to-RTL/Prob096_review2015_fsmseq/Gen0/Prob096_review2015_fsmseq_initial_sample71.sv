module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
typedef enum {Idle, S1, S2, S3, Found} state_t;

// Initialize the current state to Idle
state_t current_state = Idle;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= Idle;
        start_shifting <= 0;
    end else begin
        case (current_state)
            Idle: begin
                if (data) begin
                    current_state <= S1;
                end else begin
                    current_state <= Idle;
                end
                start_shifting <= 0;
            end
            S1: begin
                if (data) begin
                    current_state <= S2;
                end else begin
                    current_state <= Idle;
                end
                start_shifting <= 0;
            end
            S2: begin
                if (!data) begin
                    current_state <= S3;
                end else begin
                    current_state <= S1;
                end
                start_shifting <= 0;
            end
            S3: begin
                if (data) begin
                    current_state <= Found;
                end else begin
                    current_state <= Idle;
                end
                start_shifting <= 0;
            end
            Found: begin
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule