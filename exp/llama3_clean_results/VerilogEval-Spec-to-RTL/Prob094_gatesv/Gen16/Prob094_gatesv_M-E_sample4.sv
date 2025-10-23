module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    always_comb begin
        out_both = 4'b0;
        out_any = 4'b0;
        out_different = 4'b0;
        
        // Calculate out_both
        for (int i = 0; i < 3; i++) begin
            out_both[i] = in[i] & in[i+1];
        end
        
        // Calculate out_any
        out_any[0] = in[0];
        for (int i = 1; i < 4; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
        
        // Calculate out_different (with wrap-around for the last bit)
        for (int i = 0; i < 4; i++) begin
            if (i == 3) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end
endmodule