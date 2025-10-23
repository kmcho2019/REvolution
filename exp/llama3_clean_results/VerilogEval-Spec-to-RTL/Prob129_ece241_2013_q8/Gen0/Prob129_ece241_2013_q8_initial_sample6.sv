module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
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
            if (!x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
    endcase
end

// Output logic
assign z = (state == S2) && x;

endmodule