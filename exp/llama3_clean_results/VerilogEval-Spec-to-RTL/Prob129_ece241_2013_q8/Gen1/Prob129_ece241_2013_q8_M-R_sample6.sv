module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output logic z
);

// Define states
enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
} state;

// State register with asynchronous reset
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        case (state)
            S0: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (~x) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
        endcase
    end
end

// Output logic
always_comb begin
    case (state)
        S0: z = 1'b0;
        S1: z = 1'b0;
        S2: z = x;
    endcase
end

endmodule