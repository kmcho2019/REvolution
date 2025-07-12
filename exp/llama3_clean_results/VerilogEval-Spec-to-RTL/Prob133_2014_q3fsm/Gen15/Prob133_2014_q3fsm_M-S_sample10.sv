module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // Current state (0: waiting for s, 1: examining w)
reg [1:0] counter; // Counter for clock cycles
reg w_count; // Counter for 'w' values that are 1
reg z_reg; // Output z

assign z = z_reg;

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        counter <= 0;
        w_count <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // Transition from state 0 to state 1 when s = 1
                if(s) begin
                    state <= 1;
                    counter <= 1;
                    w_count <= w ? 1 : 0;
                end
            end
            1: begin
                // If s is 0, return to state 0
                if(!s) begin
                    state <= 0;
                    counter <= 0;
                    w_count <= 0;
                end
                else begin
                    // Increment counter and count 'w' values
                    counter <= counter + 1;
                    w_count <= w_count + w;

                    // Check if three cycles have passed
                    if(counter == 3) begin
                        state <= 1;
                        z_reg <= (w_count == 2) ? 1 : 0;
                        counter <= 1;
                        w_count <= w ? 1 : 0;
                    end
                end
            end
        endcase
    end
end

endmodule