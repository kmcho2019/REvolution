module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [15:0] phase_accumulator;

    always @(posedge clk) begin
        phase_accumulator <= phase_accumulator + {8'b0, freq};
        wave_out <= phase_accumulator[15];  // Use MSB as square wave output
    end

endmodule