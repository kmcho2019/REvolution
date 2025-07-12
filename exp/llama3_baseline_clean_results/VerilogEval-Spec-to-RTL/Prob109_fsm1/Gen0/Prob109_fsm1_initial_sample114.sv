module TopModule(
    input clk,
    input areset,
    input in,
    output logic out
);

typedef enum logic [0:0] {
    A,
    B
} state;

state current_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
        out <= 1'b1;
    end else begin
        case (current_state)
            A: begin
                if (~in) begin
                    current_state <= B;
                    out <= 1'b1;
                end else begin
                    current_state <= A;
                    out <= 1'b0;
                end
            end
            B: begin
                if (~in) begin
                    current_state <= A;
                    out <= 1'b0;
                end else begin
                    current_state <= B;
                    out <= 1'b1;
                end
            end
            default: begin
                current_state <= B;
                out <= 1'b1;
            end
        endcase
    end
end

endmodule