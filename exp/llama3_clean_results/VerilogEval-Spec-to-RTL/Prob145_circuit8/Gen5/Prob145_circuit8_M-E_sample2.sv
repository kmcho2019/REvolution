module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state;

always @(posedge clock or negedge clock) begin
    if (~clock) begin // Low clock phase
        if (a) begin // Reset condition
            state <= 1'b0;
            q <= 1'b0;
        end else if (p && !state) begin // Transition to active state
            state <= 1'b1;
            q <= 1'b1;
        end
    end else begin // High clock phase
        if (a) begin
            p <= 1'b1; // Set p when a is high
        end else begin
            p <= 1'b0; // Reset p when a is low
        end
    end
end

endmodule