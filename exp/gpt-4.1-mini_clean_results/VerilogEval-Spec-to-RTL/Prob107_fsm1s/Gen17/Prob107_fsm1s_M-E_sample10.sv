module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    typedef enum logic {B=1'b0, A=1'b1} state_t;
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1; // output in reset state B
        end else begin
            // Next state logic
            if (state == B) begin
                if (in == 1'b0) begin
                    state <= A;
                    out <= 1'b0;
                end else begin
                    state <= B;
                    out <= 1'b1;
                end
            end else begin // state == A
                if (in == 1'b0) begin
                    state <= B;
                    out <= 1'b1;
                end else begin
                    state <= A;
                    out <= 1'b0;
                end
            end
        end
    end

endmodule