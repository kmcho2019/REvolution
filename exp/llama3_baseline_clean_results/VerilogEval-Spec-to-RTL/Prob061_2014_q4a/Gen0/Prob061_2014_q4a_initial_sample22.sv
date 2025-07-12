module TopModule(
    input clk,  // clock signal
    input w,    // input from the previous stage
    input R,    // value to load
    input E,    // enable shift
    input L,    // load signal
    output reg Q  // output of the module
);

    // Select the input for the D flip-flop based on L and E
    always @(posedge clk) begin
        if (L) begin
            // Load R into the flip-flop when L is high
            Q <= R;
        end else if (E) begin
            // Shift w into the flip-flop when E is high and L is low
            Q <= w;
        end
    end

endmodule