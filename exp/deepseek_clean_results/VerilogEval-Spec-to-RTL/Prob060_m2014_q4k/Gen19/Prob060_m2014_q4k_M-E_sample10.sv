module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] circular_buffer;

    always @(posedge clk) begin
        if (!resetn) begin
            // Parallel load all zeros on reset
            circular_buffer <= 4'b0000;
        end else begin
            // Circular shift with new input at LSB
            circular_buffer <= {circular_buffer[2:0], in};
        end
    end

    // Output is always the MSB of the circular buffer
    assign out = circular_buffer[3];

endmodule