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
assign next_state = (state == S0 && x) ? S1 :
                    (state == S1 && !x) ? S2 :
                    (state == S2 && x) ? S1 :
                    (state == S0 && !x) ? S0 :
                    (state == S1 && x) ? S1 :
                    (state == S2 && !x) ? S0 : state;

// Output logic
assign z = (state == S2 && x);

endmodule