module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;

    // Shift register with synchronous enable
    // Shift right: new bit S goes into Q[7] (LSB)
    always @(posedge clk) begin
        if (enable) begin
            Q <= {S, Q[7:1]};
        end
    end

    // 3-level mux hierarchy to select one of Q[0..7] based on ABC
    wire mux_level1_0 = (C) ? Q[1] : Q[0];
    wire mux_level1_1 = (C) ? Q[3] : Q[2];
    wire mux_level1_2 = (C) ? Q[5] : Q[4];
    wire mux_level1_3 = (C) ? Q[7] : Q[6];

    wire mux_level2_0 = (B) ? mux_level1_1 : mux_level1_0;
    wire mux_level2_1 = (B) ? mux_level1_3 : mux_level1_2;

    wire mux_level3_0 = (A) ? mux_level2_1 : mux_level2_0;

    assign Z = mux_level3_0;

endmodule