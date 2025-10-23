module TopModule(
    input clk,
    input a,
    output reg q
);
    reg [1:0] a_history;

    always @(posedge clk) begin
        // Shift in the current 'a' sample
        a_history <= {a_history[0], a};

        // Update q according to the conditions
        if (a == 1'b0) begin
            q <= 1'b1;
        end else if (a_history == 2'b11) begin
            q <= 1'b0;
        end
        // else q keeps its previous value
    end
endmodule