module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] counter; // Counter to track the clock cycles
reg [1:0] w_count; // Counter to count the number of w = 1
reg in_state_b; // Flag to indicate if we are in state B

always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        w_count <= 0;
        in_state_b <= 0;
        z <= 0;
    end else begin
        if (~in_state_b && s) begin // Transition from state A to state B
            in_state_b <= 1;
            counter <= 1;
            w_count <= w;
        end else if (in_state_b) begin
            counter <= counter + 1;
            if (w)
                w_count <= w_count + 1;
            if (counter == 3) begin // After three clock cycles
                z <= (w_count == 2); // Set z based on the count of w = 1
                counter <= 1; // Reset the counter
                w_count <= w; // Reset the w_count
            end
        end
    end
end

endmodule