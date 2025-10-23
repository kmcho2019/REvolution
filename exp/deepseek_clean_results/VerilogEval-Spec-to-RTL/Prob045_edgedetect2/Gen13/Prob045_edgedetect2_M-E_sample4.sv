module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Previous input value
    reg [7:0] prev_in;
    // Edge type tracking (0=none, 1=rising, 2=falling)
    reg [1:0] edge_type [0:7];
    integer i;

    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Detect edge type
            if (in[i] && !prev_in[i]) begin
                edge_type[i] <= 2'b01;  // Rising edge
            end else if (!in[i] && prev_in[i]) begin
                edge_type[i] <= 2'b10;  // Falling edge
            end else begin
                edge_type[i] <= 2'b00;  // No edge
            end

            // Output any edge (rising or falling)
            anyedge[i] <= |edge_type[i];
        end
        prev_in <= in;
    end

endmodule