module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [1:0] transition [7:0];  // 2 bits per bit position: [1] = falling, [0] = rising

    integer i;

    always @(posedge clk) begin
        // First pipeline stage: detect transitions
        for (i = 0; i < 8; i = i + 1) begin
            if (prev_in[i] && !in[i]) begin
                transition[i] <= 2'b10;  // Falling edge
            end else if (!prev_in[i] && in[i]) begin
                transition[i] <= 2'b01;  // Rising edge
            end else begin
                transition[i] <= 2'b00;  // No edge
            end
        end
        prev_in <= in;
    end

    always @(posedge clk) begin
        // Second pipeline stage: generate output
        for (i = 0; i < 8; i = i + 1) begin
            anyedge[i] <= |transition[i];  // OR both bits to detect any edge
        end
    end

endmodule