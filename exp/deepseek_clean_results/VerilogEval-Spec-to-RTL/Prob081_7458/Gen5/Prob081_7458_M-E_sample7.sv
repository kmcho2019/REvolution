module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output reg p1y, p2y
);

    always @(*) begin
        // Concatenate all inputs to form address
        case ({p1a, p1b, p1c, p1d, p1e, p1f, p2a, p2b, p2c, p2d})
            // All possible combinations where p1y should be 1
            // (when either first 3-input AND or second 3-input AND is true)
            10'b111???: begin p1y = 1; p2y = p2a & p2b | p2c & p2d; end
            10'b???111: begin p1y = 1; p2y = p2a & p2b | p2c & p2d; end
            // All other cases
            default: begin
                p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
                p2y = (p2a & p2b) | (p2c & p2d);
            end
        endcase
    end

endmodule