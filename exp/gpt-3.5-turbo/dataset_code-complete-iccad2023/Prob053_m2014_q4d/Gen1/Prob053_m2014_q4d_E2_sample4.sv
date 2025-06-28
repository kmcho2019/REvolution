module TopModule (
    input clk,
    input in,
    output logic out
);

    logic dff_output;
  
    // D flip-flop
    always_ff @(posedge clk) begin
        dff_output <= in ^ dff_output;
    end

    // XOR gate
    assign out = dff_output;

endmodule