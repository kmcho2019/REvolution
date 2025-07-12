module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock or negedge clock) begin
    if (!clock && a) begin // If 'a' is high during the low clock phase
        p <= 1'b0; // Reset 'p'
        q <= 1'b0; // Reset 'q'
    end else if (clock && a) begin // If 'a' is high during the high clock phase
        p <= 1'b1; // Set 'p'
        if (p) begin // If 'p' is already set
            q <= 1'b1; // Set 'q'
        end
    end else if (clock &&!a && p) begin // If 'a' is low during the high clock phase and 'p' is set
        q <= 1'b1; // Set 'q'
    end
end

endmodule