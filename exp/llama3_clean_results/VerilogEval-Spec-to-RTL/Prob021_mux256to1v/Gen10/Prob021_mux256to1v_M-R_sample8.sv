module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    always @(*)
    begin
        case (sel)
            256'd0: out = in[3:0];
            256'd1: out = in[7:4];
            256'd2: out = in[11:8];
            // ... (add more cases for all 256 values of sel)
            256'd255: out = in[1023:1020];
            default: out = 4'd0; // default case to handle any invalid sel values
        endcase
    end

endmodule