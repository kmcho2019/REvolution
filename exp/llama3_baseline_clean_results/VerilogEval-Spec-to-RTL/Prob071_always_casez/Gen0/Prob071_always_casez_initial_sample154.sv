module TopModule(
    input [7:0] in,
    output [2:0] pos
);

    always @(in) begin
        pos = 3'd0; // initialize pos to 0
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin // if current bit is 1
                pos = i; // output the current position
                break; // stop iterating
            end
        end
    end

endmodule