module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Define states as enumerated type
    typedef enum reg {
        A = 1'b0,
        B = 1'b1
    } state_t;
    
    state_t state;

    // Combined state transition and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Asynchronous reset to state B
            out <= 1'b1;
        end else begin
            case (state)
                A: begin
                    state <= in ? A : B;
                    out <= in ? 1'b0 : 1'b1;
                end
                B: begin
                    state <= in ? B : A;
                    out <= in ? 1'b1 : 1'b0;
                end
            endcase
        end
    end

endmodule