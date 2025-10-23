module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    reg state;
    reg [1:0] prev_inputs;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            prev_inputs <= 2'b00;
            out <= 1'b0;
        end else begin
            prev_inputs <= {j,k};
            // Only update state if inputs changed
            if (prev_inputs != {j,k}) begin
                state <= (state & ~k) | (~state & j);
            end
            // Registered output
            out <= state;
        end
    end
endmodule