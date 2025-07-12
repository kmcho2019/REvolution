module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    logic [3:0] delay_reset;

    always_ff @(posedge clk) begin
        delay_reset <= {delay_reset[2:0], reset};
    end

    assign shift_ena = delay_reset[3] || delay_reset[2] || delay_reset[1] || delay_reset[0];

endmodule