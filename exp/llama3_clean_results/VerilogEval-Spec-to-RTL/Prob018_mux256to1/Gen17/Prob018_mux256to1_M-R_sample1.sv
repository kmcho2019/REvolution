module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output reg out
);

    always @(*) begin
        case (sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            // ... and so on for all 256 cases
            256'd255: out = in[255];
            default: out = 1'b0; // default case to handle invalid select values
        endcase
    end

endmodule