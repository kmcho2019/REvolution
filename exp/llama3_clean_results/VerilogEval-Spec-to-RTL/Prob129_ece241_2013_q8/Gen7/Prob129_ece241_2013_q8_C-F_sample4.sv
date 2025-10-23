module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states using one-hot encoding for potential area and power savings
enum logic [1:0] {S0 = 2'b001, S1 = 2'b010, S2 = 2'b100} state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        case (state)
            S0: state <= x ? S1 : S0;
            S1: state <= ~x ? S2 : S1;
            S2: state <= x ? S1 : S0;
        endcase
    end
end

// Output logic
assign z = (state == S2) && x;

endmodule