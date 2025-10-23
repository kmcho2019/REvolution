module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    reg state;
    reg [1:0] prev_inputs;
    wire inputs_changed = (prev_inputs != {j,k});
    wire clk_en = areset | inputs_changed;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            prev_inputs <= 2'b00;
        end else if (clk_en) begin
            state <= (state & ~k) | (~state & j);
            prev_inputs <= {j,k};
        end
    end
    
    always @(posedge clk) begin
        out <= state;
    end
endmodule