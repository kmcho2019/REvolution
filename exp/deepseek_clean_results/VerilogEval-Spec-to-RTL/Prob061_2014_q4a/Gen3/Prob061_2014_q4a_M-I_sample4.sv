module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

(* use_dsp48 = "no", shreg_extract = "no" *)  // Prevent unnecessary DSP/SRL usage
always @(posedge clk) begin
    case ({L, E})
        2'b10, 2'b11: Q <= R;  // Load has priority
        2'b01:       Q <= w;   // Shift when enabled
        default:     Q <= Q;   // Explicit hold state
    endcase
end

endmodule