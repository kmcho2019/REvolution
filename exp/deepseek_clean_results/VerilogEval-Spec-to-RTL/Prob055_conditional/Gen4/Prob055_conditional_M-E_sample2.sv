module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    reg [3:0] min_candidate = 4'b1111; // Initially all are candidates
    reg [7:0] min_value;
    integer i;

    always @(*) begin
        min_candidate = 4'b1111; // Reset for new evaluation
        for (i = 7; i >= 0; i = i - 1) begin
            // Check current bit for all active candidates
            if (min_candidate[0] && a[i]) min_candidate[0] = 0;
            if (min_candidate[1] && b[i]) min_candidate[1] = 0;
            if (min_candidate[2] && c[i]) min_candidate[2] = 0;
            if (min_candidate[3] && d[i]) min_candidate[3] = 0;
            
            // If only one candidate remains, we can exit early
            if ($countones(min_candidate) == 1) break;
        end

        // Select the minimum value based on the final candidate vector
        case (1'b1)
            min_candidate[0]: min_value = a;
            min_candidate[1]: min_value = b;
            min_candidate[2]: min_value = c;
            min_candidate[3]: min_value = d;
            default: min_value = a; // should never happen
        endcase
    end

    assign min = min_value;

endmodule