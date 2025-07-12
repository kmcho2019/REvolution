module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Reset logic
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z = 1'b1; // Assert output when sequence is detected
            end else begin
                next_state = S0;
                z = 1'b0;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        S0: z = 1'b0;
        S1: z = 1'b0;
        S2: begin
            if (x) begin
                z = 1'b1; // Assert output when sequence is detected
            end else begin
                z = 1'b0;
            end
        end
    endcase
end

endmodule