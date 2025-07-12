module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // Initialize pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin // If the current bit is '1'
                pos = i; // Output the current position
                break; // Stop searching
            end
        end
    end

endmodule